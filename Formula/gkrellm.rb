class Gkrellm < Formula
  desc "Extensible GTK system monitoring application"
  homepage "https://billw2.github.io/gkrellm/gkrellm.html"
  url "http://gkrellm.srcbox.net/releases/gkrellm-2.3.10.tar.bz2"
  sha256 "8b9ec8baadcd5830c6aff04ba86dc9ed317a15c1c3787440bd1e680fb2fcd766"
  revision 1
  head "https://git.srcbox.net/gkrellm", :using => :git

  bottle do
    sha256 "7deb82cd7fe3c9cb715f1be733b8f89692ab66fe0e603fd36d617d946d4e319b" => :mojave
    sha256 "e84742cdd42e7584a6814c9c4cf2b8d7245d48ae0723b77c236f011354ac71e1" => :high_sierra
    sha256 "53888d3166533669a8649ef295c28813dcb0c051ed4146a33452f90c860978a8" => :sierra
    sha256 "7cc7e94022669c80d1035efa738388fb264f50e4edaf0720db216f58b0ad3dab" => :el_capitan
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
  depends_on "openssl"
  depends_on "pango"

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
      assert_predicate testpath/"test.pid", :exist?
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
