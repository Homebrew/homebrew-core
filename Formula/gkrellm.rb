class Gkrellm < Formula
  desc "Extensible GTK system monitoring application"
  homepage "https://billw2.github.io/gkrellm/gkrellm.html"
  url "http://gkrellm.srcbox.net/releases/gkrellm-2.3.10.tar.bz2"
  sha256 "8b9ec8baadcd5830c6aff04ba86dc9ed317a15c1c3787440bd1e680fb2fcd766"
  revision 2

  bottle do
    sha256 "79acf87da145a4e76c0bbee42ce637c4816773df1e78a595d5e7b9e6604b95ea" => :mojave
    sha256 "8099b25d57c72ab6c7b49b2dbbfed617dac32007ad62bfc3cda5f1db5e75e1a5" => :high_sierra
    sha256 "80da7966c004a81c4eb6bbfcd3f2f99be679d3cf66ffe1d0b1e6a39255509f2a" => :sierra
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
