class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.8.0.tar.gz"
  sha256 "756ce2c6241b2104dc19097488225de559ac1802a175be0233cfb6fbc02f3bd2"
  license "GPL-2.0"
  revision 2
  head "https://github.com/cmus/cmus.git"

  bottle do
    sha256 "139bf64752c28ed24e016dfcde2d294e8594430dab9bb8b7df80b4e2e1c06cd1" => :catalina
    sha256 "4c5095917ced94e028bf33b8330f46dd692ab62fbd0304d14f1d9664b8045b3d" => :mojave
    sha256 "a6f14946798e6b75c0102801a7f0bf85d5601914f0e2e7d9206664d0b86d6203" => :high_sierra
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
