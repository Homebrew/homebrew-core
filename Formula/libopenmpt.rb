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
    sha256 cellar: :any,                 arm64_ventura:  "c0d709280260bcba5adf6c2399bf7d35ad81f089944df70563ab8071b21c8c5b"
    sha256 cellar: :any,                 arm64_monterey: "a3344d3487ebee041561c16d12e843608a8a8c1b224217cccd143e6ba29f5539"
    sha256 cellar: :any,                 arm64_big_sur:  "4b08242f73671a936e1583f50a8a834b0edc9bb4e58e264916bd929aeb2f9995"
    sha256 cellar: :any,                 ventura:        "3d0ae02ad062948090e72f90316f4ab0b1d8c6f2e0dc76826b33d3efd6ff5975"
    sha256 cellar: :any,                 monterey:       "7aa839f51d2104b95ac68db16ee604dc9ebef9798cbed1986243f134bb8af5e9"
    sha256 cellar: :any,                 big_sur:        "1620791053a7c38f7244caef52c54c8da31c504ab1e2bdae13585b660dcf8512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ef57f82b04d79a223a887930ce20f929ad67e2aae0ab821098398a3051959dd"
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
