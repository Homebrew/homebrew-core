class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.9.1.tar.gz"
  sha256 "6fb799cae60db9324f03922bbb2e322107fd386ab429c0271996985294e2ef44"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/cmus/cmus.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "c8442ac4518d870f91a68e917251fb9050ba7f477fce412597eabd4ab68c8008"
    sha256 arm64_big_sur:  "e9bf47dcc8350d948fc841f18c0b5b68d72299f488338a68d0df2e52245f62aa"
    sha256 monterey:       "d993861d232ff31bf395af15846d39e6d5872c6b0d075ae227983b3296e4841c"
    sha256 big_sur:        "6704b64f4bd2e163be11e1146e076252ec6af54f6eaff80cb54bcce7b2047214"
    sha256 catalina:       "185a420e4b5b7ac9a88232f0fe74d1110483ea682a1b9198335e9cd8b733d3a8"
    sha256 x86_64_linux:   "8b51575dd6d4de96abb655cccd3bccbcb77018b15b2383172aac3d465e0e2fa6"
  end

  depends_on "pkg-config" => :build
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "libcue"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "mp4v2"
  depends_on "opusfile"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    system "./configure", "prefix=#{prefix}", "mandir=#{man}",
                          "CONFIG_WAVPACK=n", "CONFIG_MPC=n"
    system "make", "install"
  end

  test do
    system "#{bin}/cmus", "--plugins"
  end
end
