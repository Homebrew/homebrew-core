class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/refs/tags/0.5.10.tar.gz"
  sha256 "84734a0b89c95f4834fd55c26b362be2fb846445383e37f5209691694ad2b5de"
  license "LGPL-2.1-or-later"
  head "https://github.com/libproxy/libproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "f7eaa3e6e5af9257d15489974195fd4e3d88620ff7955a0af33ec49f95557dfc"
    sha256 cellar: :any, arm64_sonoma:  "40812832dc58d0fa9c0f10d23a7427d056a75279749704a950c5aa7b5b1a99f7"
    sha256 cellar: :any, arm64_ventura: "e8c79a7c9edf1fd1e2d2a964f5b8d4c02dd3d3c8a19d1ddd76ccb8a044f8dab7"
    sha256 cellar: :any, sonoma:        "5d3665e4b0fc076d74ea56670065bd44636a3c629963d2dcbbbb49b6760c9e51"
    sha256 cellar: :any, ventura:       "ba534efd1196f5c2b1caa7b94c8623b2b761baac55ade72f2af56890226a2d87"
    sha256               arm64_linux:   "9f9f6b5237402cf947c9825b6ab71a3d11072deba183279b77356e320976b110"
    sha256               x86_64_linux:  "9182cef72b24d30b579921d92af330f4a7f9655d60d43d8e3ce9cade2f3189d6"
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
