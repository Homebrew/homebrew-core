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
    sha256 cellar: :any,                 arm64_monterey: "e7ddb326f433c3ec158a90021a6f4da08ba828765819a7dbc3efb91a5c04cb0e"
    sha256 cellar: :any,                 arm64_big_sur:  "849ae331cd50ec2781e73012439af4e821485ee5a118cb6062e38d7d3494f047"
    sha256 cellar: :any,                 monterey:       "cf53e386bed794870774702da273b24dd6027469ae38dbbac2759bafc8c35c96"
    sha256 cellar: :any,                 big_sur:        "b27b9bbcb88e91a7c308a3d915eb71c7802007ea1da91d11e8d56ef4b4386b4d"
    sha256 cellar: :any,                 catalina:       "0fbd295a8d1ecb857ed7dac7be7d64317e52c9ed53a99c6666297e035ed6aa30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abf3099e0d0dd9b289c81355f1d4c5512ac8c09583377ef0decb32f4fa383f74"
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
