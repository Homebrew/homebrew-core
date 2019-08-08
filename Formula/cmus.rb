class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.8.0.tar.gz"
  sha256 "756ce2c6241b2104dc19097488225de559ac1802a175be0233cfb6fbc02f3bd2"
  revision 1
  head "https://github.com/cmus/cmus.git"

  bottle do
    sha256 "947c5455a55f02ebe1e73e3235568a08fc12f1dd997a28126e63f2870d12effb" => :mojave
    sha256 "78634cac6ac5312fad50c2018626abc36b1882e676d605dae4dff6c49d2163c2" => :high_sierra
    sha256 "29096641762614b528f5077100d98a3572d6404523ece6a36c6ca12f30f10d07" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "faad2"
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
