class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.6.10+release.autotools.tar.gz"
  version "0.6.10"
  sha256 "c25be8dc0dac23cec025487e58f195e4d14f7d94aeddd5fe46b21c04f1ce2774"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "907b6f89e70454ca4f806843a53c3382f8b7f6d068c2d42beaeb7ec59fed3c88"
    sha256 cellar: :any,                 arm64_monterey: "d3e56b0c533337f1af554b89739d2eaebf6bdbe019822ed268c7065258cc0e00"
    sha256 cellar: :any,                 arm64_big_sur:  "bd6606bfebf3003f039a9bd3aa8f5227fb0e18fc7d91de9250bcb6d869a3a54b"
    sha256 cellar: :any,                 ventura:        "27b15cd2d4b4f0472cdb2547553c41342c0f4494fe90ea2a899e7abcd698233a"
    sha256 cellar: :any,                 monterey:       "0315b2a39bdfbd99e15d45b8434b0763011d8b862bda8a156cf8a7c59969d6a3"
    sha256 cellar: :any,                 big_sur:        "b43c4c840ac1af30446fbca5f4fddd11c7f6c1f9cc67dce26198ef9bd793a68e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8574b6de9133965acc40b62237d053125274af29058d08fe63a4a3c30a65e1c"
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
