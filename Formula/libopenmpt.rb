class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.6.6+release.autotools.tar.gz"
  version "0.6.6"
  sha256 "6ddb9e26a430620944891796fefb1bbb38bd9148f6cfc558810c0d3f269876c7"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6b12d801cc1c4746a6eb7f15407b733d8396ec258696a26f71d5aae2abc15d00"
    sha256 cellar: :any,                 arm64_monterey: "2955f9a5f52dc6a003ad3c2800f1258167d07488386e146fa7503220d2fb77a4"
    sha256 cellar: :any,                 arm64_big_sur:  "b1cb3909d998bc05e41976de735f83aa15b43848ba4aa5304d7cd512b7b127c1"
    sha256 cellar: :any,                 ventura:        "8a3ec0b3cd549a9354e393527bdd0389962cd90ef055d41f192a4694c71f7ecd"
    sha256 cellar: :any,                 monterey:       "f2ff766711aaf89f9d7c45e71f1c6dfaf60ceaee2cf561dfd1baf7a13146a2ba"
    sha256 cellar: :any,                 big_sur:        "2e53000dcb09f90d5862515855ee7a7496d12f2bba6f931e66bb5d6191575f10"
    sha256 cellar: :any,                 catalina:       "4f0734db9d7bae065f76bf280681a69706b2472ac874b9be1550278506f4fd3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96fc9cbf713f0691acf07dbc7500ceaa6af7090ab2dd98a6e524fdbbb5867636"
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
