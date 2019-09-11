class Gkrellm < Formula
  desc "Extensible GTK system monitoring application"
  homepage "https://billw2.github.io/gkrellm/gkrellm.html"
  url "http://gkrellm.srcbox.net/releases/gkrellm-2.3.11.tar.bz2"
  sha256 "1ee0643ed9ed99f88c1504c89d9ccb20780cf29319c904b68e80a8e7c8678c06"
  revision 2

  bottle do
    sha256 "641f4e27054dacd25dd91dc2f6d8d608918321ae06cf06eb17f2d62132125e7a" => :mojave
    sha256 "71f4e92d308a39b38ac97bf2f06cea12ccee0072cbd27b8443e1d33f11fb7c5b" => :high_sierra
    sha256 "f90adbb22bdbc169d95c932591d4c5a7c5e869f61c79744bb743c50a4698acc9" => :sierra
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
  depends_on "openssl@1.1"
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
