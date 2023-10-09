class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/refs/tags/0.5.3.tar.gz"
  sha256 "0d8d8e4dd96239ba173c2b18905c0bb6e161fd5000e1e0aeace16f754e9a9108"
  license "LGPL-2.1-or-later"
  head "https://github.com/libproxy/libproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "773ba3cafbde86e4cf8825269a7a40313dbd45a9b564ad8002177fa1dc8e61bb"
    sha256 cellar: :any, arm64_ventura:  "075b1519da1ad392cf866beec168b4f715177d1543e900e7ede7ae8507dfb3b7"
    sha256 cellar: :any, arm64_monterey: "aad46ee51cd177d04ea1cfd7605b2b603f196fe1e301563191ffe4d003fe85ad"
    sha256 cellar: :any, arm64_big_sur:  "b8fbd8ad12afa8dc832ba23c7b25fad26fb8499335f73bbe13b56a0aa69cb8f1"
    sha256 cellar: :any, sonoma:         "f7d3f86cc10148bb6a714424260ec4623827355695b0511f9e659b4c66672830"
    sha256 cellar: :any, ventura:        "c3bac36fac9fd9a9863dfb2a94b285cde660387b04d7daf3ec50c76ae39097a2"
    sha256 cellar: :any, monterey:       "a29a26ef4cd57036219b82d2866f7daf19d55711c265e8aa6b0a57f9c2c09771"
    sha256 cellar: :any, big_sur:        "9b9351680c2be932c8da8db56563a7110225784f0d8f92ab0a149081d258618d"
    sha256               x86_64_linux:   "20ae30585fffb6e10c91f6d993574b7b6ff3da6c9d5e1ece42021eead1a8fcc4"
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
