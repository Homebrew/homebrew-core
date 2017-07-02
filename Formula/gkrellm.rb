class Gkrellm < Formula
  desc "Extensible GTK system monitoring application"
  homepage "https://billw2.github.io/gkrellm/gkrellm.html"
  url "http://gkrellm.srcbox.net/releases/gkrellm-2.3.10.tar.bz2"
  sha256 "8b9ec8baadcd5830c6aff04ba86dc9ed317a15c1c3787440bd1e680fb2fcd766"
  head "https://git.srcbox.net/gkrellm", :using => :git

  bottle do
    sha256 "7c7f91f9fc1c44558fed587a1bcecde335f6031acf4561588ccb53f51062eb5e" => :sierra
    sha256 "8a01923e37d91e39505b248213eb7e8aa116a4fa16d325d8a7e0fa141aaa6bdd" => :el_capitan
    sha256 "c776866142f6e992b4fb86b5447a339221b41f074d0de3a4485b52364cc8958f" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "pango"
  depends_on "gobject-introspection"
  depends_on "openssl"

  def install
    system "make", "INSTALLROOT=#{prefix}", "macosx"
    system "make", "INSTALLROOT=#{prefix}", "install"
  end

  test do
    pid = fork do
      exec "#{bin}/gkrellmd --pidfile #{testpath}/test.pid"
    end
    sleep 2

    begin
      assert File.exist?("test.pid")
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
