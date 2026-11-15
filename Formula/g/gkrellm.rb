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
    rebuild 1
    sha256 arm64_golden_gate: "b2f3336e082ca1453e99d97a93e9ed430995a675a5e77a208ee58ac208e2910a"
    sha256 arm64_tahoe:       "581345f1aeb95ba675efa58f0146116db5753788c370d4f7c47adf58acbdd565"
    sha256 arm64_sequoia:     "a916eba8009a177b6361c20b42ee40c5db0dc9ffd5d36af504ddff64a61f939b"
    sha256 arm64_linux:       "88f4670d5555924f1077b713473724db3b9472ceba5e864849828f2c20aeb67e"
    sha256 x86_64_linux:      "7593315e3dab7c523b936a5ab033e117df9b6851728939ed3be277b3915ecdab"
  end

  # Can be undeprecated if upstream moves to GTK 3 / cairo:
  # https://git.srcbox.net/gkrellm/gkrellm/issues/1
  deprecate! date: "2026-08-28", because: "needs EOL `gtk+`"
  disable! date: "2027-08-28", because: "needs EOL `gtk+`"

  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+" # GTK3 issue: https://git.srcbox.net/gkrellm/gkrellm/issues/1
  depends_on "openssl@4"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libice"
    depends_on "libsm"
    depends_on "libx11"
  end

  allow_network_access! :test

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
