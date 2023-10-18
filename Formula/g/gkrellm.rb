class Gkrellm < Formula
  desc "Extensible GTK system monitoring application"
  homepage "https://billw2.github.io/gkrellm/gkrellm.html"
  url "http://gkrellm.srcbox.net/releases/gkrellm-2.3.11.tar.bz2"
  sha256 "1ee0643ed9ed99f88c1504c89d9ccb20780cf29319c904b68e80a8e7c8678c06"
  revision 3

  livecheck do
    url "http://gkrellm.srcbox.net/releases/"
    regex(/href=.*?gkrellm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "6816f085dc6c091b9a94131eed3fb6b8b0a12dcb7ad89cb279d5dc89a15e3f94"
    sha256 arm64_ventura:  "dd870efc661b45e29ad69fc2413a3d78069763d01e0b1b7c5234df19bf3c102f"
    sha256 arm64_monterey: "3983e2437e1930f66c19ba5dfffe300ec7624aad43a3e0b4d4b49ead2ec70167"
    sha256 arm64_big_sur:  "e2722e8eef55bf785c42548a507355bd44df8c6df7dcc40a8c2f5b40f8c2c290"
    sha256 sonoma:         "caca1f881e66e407d6042369a2195856b9002960fab1135fb350437f17f7649a"
    sha256 ventura:        "a2ce7b7c4e41372864b7de15a19d649dbbdb6bcd6c8de4bf1b96264358d834fb"
    sha256 monterey:       "5871cd121aa7aa4b0bfc6af75e8e718a1e49d560f23efb2a98ad1255167143d9"
    sha256 big_sur:        "7a4eaed03a5da148716b65e02cdddb03b13c3c1bdf6f43c65cd4833be4d09166"
    sha256 x86_64_linux:   "5ce7b72ca02d9657b676754d3bcf936e8fba6c4f0aa4fa2e76520bd31f5975eb"
  end

  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+" # GTK3 issue: https://git.srcbox.net/gkrellm/gkrellm/issues/1
  depends_on "openssl@3"
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
