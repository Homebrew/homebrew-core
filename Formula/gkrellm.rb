class Gkrellm < Formula
  desc "Extensible GTK system monitoring application"
  homepage "https://billw2.github.io/gkrellm/gkrellm.html"
  url "http://gkrellm.srcbox.net/releases/gkrellm-2.3.10.tar.bz2"
  sha256 "8b9ec8baadcd5830c6aff04ba86dc9ed317a15c1c3787440bd1e680fb2fcd766"
  head "https://git.srcbox.net/gkrellm", :using => :git

  bottle do
    sha256 "a6024661e26bae0bafe492b249b7fe64e72801d3d50310b36abc5dd05620e7ea" => :sierra
    sha256 "1b33628604f2b3577d020a32ddf61af1dd4ae3cf7f52fc62617ea2a842e4d842" => :el_capitan
    sha256 "64e1bf668b44b8a056d3f07d0644012f5778b42654d1d656bcba595f640786c7" => :yosemite
    sha256 "f4ff4fc7fecd7ec1c057a329789546e7533c6fee7bf59b19901027c777ad9395" => :mavericks
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
