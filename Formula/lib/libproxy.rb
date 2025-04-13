class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/refs/tags/0.5.9.tar.gz"
  sha256 "a1976c3ac4affedc17e6d40cf78c9d8eca6751520ea3cbbec1a8850f7ded1565"
  license "LGPL-2.1-or-later"
  head "https://github.com/libproxy/libproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "ea05222062747c5eb6ad1c2b6702f15fc17449dab974454882a7730ab71a57fe"
    sha256 cellar: :any, arm64_sonoma:  "98cbc8687ff557d1c3846bee65cbd2bf1bb28c12ab11fcf5a508364147e623d8"
    sha256 cellar: :any, arm64_ventura: "3b1fadfe0d664fba4cb8490bf6b60d6c60fba021ecbdf2392baa3883c7802be8"
    sha256 cellar: :any, sonoma:        "33bcfa11bc19106a39baec8b02ea502d5dc8b33d3337e2d59f8b10027f1d6ad5"
    sha256 cellar: :any, ventura:       "e1c5deed45524a740381a8cfb7298b8e2cce31574addda6143546b07517a2535"
    sha256               arm64_linux:   "739f6c10726d3f147797cea43ca60c2306ec02b9064927ac8313a84f96ea87b8"
    sha256               x86_64_linux:  "c49f1a448cfc3917e90a0d189b88bfaee1573c717d119f944d13abd8047c7e3a"
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
