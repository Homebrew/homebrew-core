class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.6.9+release.autotools.tar.gz"
  version "0.6.9"
  sha256 "479e975abb7dc0fa9cad41bdd31f255d78d43e0726546208058d3c3fcf7b6e5a"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d26c7f545c60942b6be085427a04f2095757360d76c13449c2c249f6650784bf"
    sha256 cellar: :any,                 arm64_monterey: "f4b597bef6d550a600c0f8da48f945b84e15c5c5c34412262c47bd8ce48134e1"
    sha256 cellar: :any,                 arm64_big_sur:  "f517f8b3425216929f10c9ce2c0e2145aac5fca5b728261cd206f32259c61e20"
    sha256 cellar: :any,                 ventura:        "25c30d688920459741a3985d60d0c131b8404697e61d20219e8dbfbdbc292802"
    sha256 cellar: :any,                 monterey:       "779936bf38454771e814d171c21cb7c7c27f0c3de0382f4fe6e2e18ddb8f3091"
    sha256 cellar: :any,                 big_sur:        "f3df2f8b90f0967f8bed32e6026894dee8f69d25cdc5f4fe928bcc8c8f1a50d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a420ac70278e69840bb1e2f43bdc1ff4a41a37fddb17671e99144ef627e46a3e"
  end

  depends_on "pkg-config" => :build

  depends_on "flac"
  depends_on "libogg"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pulseaudio"
  end

  fails_with gcc: "5" # needs C++17

  resource "homebrew-mystique.s3m" do
    url "https://api.modarchive.org/downloads.php?moduleid=54144#mystique.s3m"
    sha256 "e9a3a679e1c513e1d661b3093350ae3e35b065530d6ececc0a96e98d3ffffaf4"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-vorbisfile"
    system "make"
    system "make", "install"
  end

  test do
    resource("homebrew-mystique.s3m").stage do
      output = shell_output("#{bin}/openmpt123 --probe mystique.s3m")
      assert_match "Success", output
    end
  end
end
