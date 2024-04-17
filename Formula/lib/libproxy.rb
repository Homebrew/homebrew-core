class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/refs/tags/0.5.5.tar.gz"
  sha256 "11a2eace773755e79b8d37833985ce475aed4ca4d3e6656defd5eef67b5a00f1"
  license "LGPL-2.1-or-later"
  head "https://github.com/libproxy/libproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "f7af9bb48495f511c57183b47a7d3ac8bb4ead48a50b252348ae9294ea2921a2"
    sha256 cellar: :any, arm64_ventura:  "5aedc5db073fbbc9142e17999de0e4337063099c9501e2f23032661ad1a47adb"
    sha256 cellar: :any, arm64_monterey: "4fb3913d08421f55f9e917bda3477bcc196a01c7c878b6496ebef53a1915abb1"
    sha256 cellar: :any, sonoma:         "9b03479d1716f047f848a619107a2d4324cdd8486422ad03eee056580d0ecbda"
    sha256 cellar: :any, ventura:        "cf4417118d857f73f7688d284cc2bb36ac87cfd071accd4df36f7badda2c1002"
    sha256 cellar: :any, monterey:       "faa37948031b1cb36785e478b50b130d94cf0708b35950963b87c23f74b2bbe7"
    sha256               x86_64_linux:   "810b20dc5fcb5ee6b85cd8071fa529e3c3c9c61115347633c1a0d957363b7af0"
  end

  depends_on "gobject-introspection" => :build
  depends_on "gsettings-desktop-schemas" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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
