class Gkrellm < Formula
  desc "Extensible GTK system monitoring application"
  homepage "https://billw2.github.io/gkrellm/gkrellm.html"
  url "https://gkrellm.srcbox.net/releases/gkrellm-2.5.1.tar.bz2"
  sha256 "089e3c1ed398482e682c9900b504ea166a6144a6c9fa041e70c5bbca6b177e63"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gkrellm.srcbox.net/releases/"
    regex(/href=.*?gkrellm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "936a8c81763c7bec55bff88e4191b3c550629ea638728b94924ad7548a52f663"
    sha256 arm64_sequoia: "cf13c52a8564497ea6b470048141efec9afad5fe0173982a1a8e8d7f6e6211eb"
    sha256 arm64_sonoma:  "c2113a61b119137b16dcc32073cfbca1851e8def91cf7a7588628e01cb29d5b6"
    sha256 sonoma:        "5580325f07672b8271d4dfd69a7018e9d6b242a695fc4f62903479cd83ab120b"
    sha256 arm64_linux:   "29063e4bc0c06e3e6c1328fad75f9f1a5061a1d66d41bfcbe16a7faa91136817"
    sha256 x86_64_linux:  "f3d9b23caf99e6749de17b505878868a235bb4e7cca6143470c32335a6a1fe7a"
  end

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+" # GTK3 issue: https://git.srcbox.net/gkrellm/gkrellm/issues/1
  depends_on "openssl@3"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
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
    begin
      sleep 2
      assert_path_exists testpath/"test.pid"
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
