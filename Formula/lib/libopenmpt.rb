class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.7.2+release.autotools.tar.gz"
  version "0.7.2"
  sha256 "509143e5a4f3b13dd98eae289bfec1b564eddd71bbc7ca7864b82835e31330e1"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4978819f7b5215dced7ce0cc712989c831e796476cf0d0be78614ce034c57a27"
    sha256 cellar: :any,                 arm64_monterey: "867eff2859faebaceb5476e001f0a66e80789593dc18eae5003706105a0efa1f"
    sha256 cellar: :any,                 arm64_big_sur:  "bf1050b7182dc39a6e615ba017ea9b5d08366f86f695adcbae17326f5a8dfc74"
    sha256 cellar: :any,                 ventura:        "1d873784a8418e77be4b5270175d463a9b0e17147c5e47d2e279b819dfeace20"
    sha256 cellar: :any,                 monterey:       "5ed62334006750ae778c7b9161d0c86dfe2006fd86d411eec5f35da79b5c6c81"
    sha256 cellar: :any,                 big_sur:        "4cf884ba75fdc880bd229fc5452893141246844b5cb754dd5f2bba48cc9c38d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2a63dac703d25586e61887078961cf9e8dcef8fc2797b0ea93726d2110a31a4"
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
