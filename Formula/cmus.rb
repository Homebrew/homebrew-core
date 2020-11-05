class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.8.0.tar.gz"
  sha256 "756ce2c6241b2104dc19097488225de559ac1802a175be0233cfb6fbc02f3bd2"
  license "GPL-2.0"
  revision 4
  head "https://github.com/cmus/cmus.git"

  bottle do
    sha256 "28bcd80ed26797cfbf1d7e0b42da105fcf431e8ddf268410a9d48def8c5c9b6b" => :catalina
    sha256 "04bb64db2401fc5007bbb82746676c789ef33d83415a7d56235ded3983bb0e12" => :mojave
    sha256 "d81b4668ed5acac3d758bd90b79c01ec12f3ea51186f804941f4d3418c28c72a" => :high_sierra
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

  def install
    system "./configure", "prefix=#{prefix}", "mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/cmus", "--plugins"
  end
end
