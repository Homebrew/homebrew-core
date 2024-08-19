class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/refs/tags/0.5.8.tar.gz"
  sha256 "64e363855012175bf796b37cacddf7bc7e08af0bf406eea94b549ce207987d3e"
  license "LGPL-2.1-or-later"
  head "https://github.com/libproxy/libproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "8502495b79120ea9ad1b682050a5301035ec705e579b297e17080d155578b386"
    sha256 cellar: :any, arm64_ventura:  "a7fe2b0cdf6f3c21381ac5e069f81b699e750c8df561b2d2853998acb684cb14"
    sha256 cellar: :any, arm64_monterey: "028921c7f386ae5e359672b3328e90f853b17a1388175e2ea334af84d24d5530"
    sha256 cellar: :any, sonoma:         "329c947ca753ff82b6eeb1582229f1eee3a445a313bd8f3a08d9411d0c986eac"
    sha256 cellar: :any, ventura:        "a582a209110cef3e51b0e0de3d4c95c61f813db3056b81b67a7c0500f0d3c952"
    sha256 cellar: :any, monterey:       "762d7caf7527a710c572fc7e8991183707f8a6f6dbd04ef0ae00f53c9e68ff24"
    sha256               x86_64_linux:   "b965dcf27682322b59b42ebb46206910ffa3c6b6d1abae45f119bd6c688ef98c"
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
