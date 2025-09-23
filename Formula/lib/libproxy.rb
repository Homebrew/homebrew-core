class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/refs/tags/0.5.11.tar.gz"
  sha256 "b364f4dbbffc5bdf196330cb76b48abcb489f38b1543e67595ca6cb7ec45d265"
  license "LGPL-2.1-or-later"
  head "https://github.com/libproxy/libproxy.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1b7b6d06d451c95bdd18e29dd262531ce678918571606fa04cea73c868e64ff6"
    sha256 cellar: :any, arm64_sequoia: "63f93cdef3537f104f1f06ec3d0d62b75d03e93576681d8a0b053d0430f25063"
    sha256 cellar: :any, arm64_sonoma:  "b1fb72115973836c39df65c3d2ece7cadf3a4f99d571613002250d4912d343c3"
    sha256 cellar: :any, arm64_ventura: "780f1242b5a624e0456a674c69a5a3f86ac03f0c02bd1809286e810cf835d9e8"
    sha256 cellar: :any, sonoma:        "6ba9c70879482d33dab24c03b60fb0441049bf2c0ec01b89aa17340b90475235"
    sha256 cellar: :any, ventura:       "65dac392147c2ac7a2e59d2a2d0be0d4110a186d3fa0bb548e03a55744711fda"
    sha256               arm64_linux:   "c1dea00b987ac047a2d5094b41e91a80c942d3af1d9cdbcf619124a0ae1df985"
    sha256               x86_64_linux:  "d5c21bbc7b8c82ed51f2fa4e6bf436359de15db0f475fbb37b42d9fd80229b26"
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
