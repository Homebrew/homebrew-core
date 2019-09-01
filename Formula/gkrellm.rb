class Gkrellm < Formula
  desc "Extensible GTK system monitoring application"
  homepage "https://billw2.github.io/gkrellm/gkrellm.html"
  url "http://gkrellm.srcbox.net/releases/gkrellm-2.3.11.tar.bz2"
  sha256 "1ee0643ed9ed99f88c1504c89d9ccb20780cf29319c904b68e80a8e7c8678c06"
  revision 1

  bottle do
    sha256 "7fdb7207792b1a1f7c58f38988445914eefbc5fd66922ff12e38c0628315f545" => :mojave
    sha256 "d03dab4ab3856ee6d5b13ea7fd5a49be95ef9474dabc855e80dad6941a858de0" => :high_sierra
    sha256 "1dfaddd23133da8e35ce1d89bd79cc2a4a1628da2e96d077d0f4be89d1d658e5" => :sierra
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
