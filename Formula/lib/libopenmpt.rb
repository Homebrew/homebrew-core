class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.7.10+release.autotools.tar.gz"
  version "0.7.10"
  sha256 "093713c1c1024f4f10c4779a66ceb2af51fb7c908a9e99feb892d04019220ba1"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e8d394a740c4eb41a712912425ea07232f42e58ce73c347b0733ded7f87d11da"
    sha256 cellar: :any,                 arm64_sonoma:  "9cea48d20fbb747270305aa204cb2c98c9ddfdf2068fe56ec97a9a12a6c8923e"
    sha256 cellar: :any,                 arm64_ventura: "649e6bb41c1ed05089dec969ceecc1409151af2f6910c93bc29756801e4ab73e"
    sha256 cellar: :any,                 sonoma:        "cb5a6a282ecc27874578de9ff4b7c994785b998139a6062c796b0b4169af378d"
    sha256 cellar: :any,                 ventura:       "5d7d658999ea49e2982530c63de3395fdf9b10b0a1371d739432e971efc1996b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98a88a98085d13090ea51204fed7dc08d8376e36ffe263b747cd86250544f350"
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
