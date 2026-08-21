class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/refs/tags/0.5.12.tar.gz"
  sha256 "a1fa55991998b80a567450a9e84382421a7176a84446c95caaa8b72cf09fa86f"
  license "LGPL-2.1-or-later"
  head "https://github.com/libproxy/libproxy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8bca46e33f84587a37f8a37a665f4672231ee8020b1b247e5c42550a64b1047c"
    sha256 cellar: :any, arm64_sequoia: "b6ccef00e59f141f4805c40e3c3036bcdf8122432091a535e66d1267ce8511fa"
    sha256 cellar: :any, arm64_sonoma:  "1309d1338d14fee12b987e1cb58694296ce746dadaf241b12158d4a216bde8d7"
    sha256 cellar: :any, sonoma:        "341f794e4ee6b4dafe8abae0e40ae482235044afbd7748d77c52325db1e13a6b"
    sha256               arm64_linux:   "8d61bdca52b59c72a01cd3ef69bbe054a1c638e45a04a9849e33902632ca25f3"
    sha256               x86_64_linux:  "32d70bc35f44a3db4bb2f34f30cc6a19c313f137caf41840a0443442c0ba661d"
  end

  depends_on "gobject-introspection" => :build
  depends_on "gsettings-desktop-schemas" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build # for vapigen

  depends_on "duktape"
  depends_on "glib"

  uses_from_macos "curl"

  on_linux do
    depends_on "dbus"
  end

  def install
    system "meson", "setup", "-Ddocs=false", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_equal "direct://", pipe_output("#{bin}/proxy 127.0.0.1").chomp
  end
end
