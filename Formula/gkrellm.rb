class Gkrellm < Formula
  desc "Extensible GTK system monitoring application"
  homepage "https://billw2.github.io/gkrellm/gkrellm.html"
  url "http://gkrellm.srcbox.net/releases/gkrellm-2.3.11.tar.bz2"
  sha256 "1ee0643ed9ed99f88c1504c89d9ccb20780cf29319c904b68e80a8e7c8678c06"
  revision 2

  livecheck do
    url "http://gkrellm.srcbox.net/releases/"
    regex(/href=.*?gkrellm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "a32eb484583ec59dd701fd6c8a7ad2ae44656bf7eab9037929b22880ebbfb7f6"
    sha256 arm64_big_sur:  "97f8dcd6b453a73339369feef0512c94129cf55e923f6d8f114a99f0ee732a88"
    sha256 monterey:       "83f96aa76c3cde2b8dbc6b3f3ead3e4d05fc7d71d5d7aada9cf3284e6455f3f8"
    sha256 big_sur:        "6571912b0f2df38104a4541d8c7fbedfa30e8d3af55249d9a447874058ef9e9b"
    sha256 catalina:       "17b040897e4feebebcca29a8d8f69fdf0cd789f07a3e479b0fe5f5f172436289"
    sha256 mojave:         "641f4e27054dacd25dd91dc2f6d8d608918321ae06cf06eb17f2d62132125e7a"
    sha256 high_sierra:    "71f4e92d308a39b38ac97bf2f06cea12ccee0072cbd27b8443e1d33f11fb7c5b"
    sha256 sierra:         "f90adbb22bdbc169d95c932591d4c5a7c5e869f61c79744bb743c50a4698acc9"
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

  on_linux do
    depends_on "libsm"
  end

  def install
    args = ["INSTALLROOT=#{prefix}"]
    args << "macosx" if OS.mac?
    system "make", *args
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
