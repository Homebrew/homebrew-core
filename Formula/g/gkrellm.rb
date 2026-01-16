class Gkrellm < Formula
  desc "Extensible GTK system monitoring application"
  homepage "https://billw2.github.io/gkrellm/gkrellm.html"
  url "https://gkrellm.srcbox.net/releases/gkrellm-2.5.0.tar.bz2"
  sha256 "68c75a03a06b935afa93d3331ca1c2d862c1d50c3e9df19d9a8d48970d766b55"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gkrellm.srcbox.net/releases/"
    regex(/href=.*?gkrellm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5886c2e585d5d4b19190a4576997d7354971489ea3d9ecc4052fcbe62434848f"
    sha256 cellar: :any, arm64_sequoia: "1dcbb331cd8c384c23a424e587bdf160ae07d0781c2fba9f56a48fbaa7d8041e"
    sha256 cellar: :any, arm64_sonoma:  "c0694f7dc9fd6bdb71296d1daec0884b56e7bb366d75e026157bd7c669117130"
    sha256 cellar: :any, sonoma:        "49c0749dd03fd3b8b4f939bc54292f7fc72b5288993ef32b2e8b29dbd74d4812"
    sha256               arm64_linux:   "6c7aef96343821bc870a4aa91e40c2f05dc440f77c8c857764abcee9e63b20be"
    sha256               x86_64_linux:  "bf71285bb443e61a5a7c4ef900a07e21799131b0a342eda2c0c7ffd205e3240f"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+" # GTK3 issue: https://git.srcbox.net/gkrellm/gkrellm/issues/1
  depends_on "openssl@3"
  depends_on "pango"

  on_macos do
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "libice"
    depends_on "libsm"
    depends_on "libx11"
  end

  def install
    args = []
    args << "-Dx11=disabled" if OS.mac?
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    pid = spawn "#{bin}/gkrellmd --pidfile #{testpath}/test.pid"
    sleep 2

    begin
      assert_path_exists testpath/"test.pid"
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
