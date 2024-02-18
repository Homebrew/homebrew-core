class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/refs/tags/0.5.4.tar.gz"
  sha256 "a6e2220349b2025de9b6d9d7f8bb347bf0c728f02a921761ad5f9f66c7436de9"
  license "LGPL-2.1-or-later"
  head "https://github.com/libproxy/libproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "0297b0a5d718f8a46a586dadf622bfe91a82a9a3bdc340599ffd6c9d3941fa8b"
    sha256 cellar: :any, arm64_ventura:  "86bd0dd0fc6e20de92515074c12584bc0437608c6afb0ae977be69781c38560a"
    sha256 cellar: :any, arm64_monterey: "b17f2841b6ba7be52a94b5deef7349a49f8617f90fd14177c7239db25295e29b"
    sha256 cellar: :any, sonoma:         "c582f90b8b8b151fd9c29acac9f210ad6e5799e53e188b7d3f7d16761e4e63ab"
    sha256 cellar: :any, ventura:        "4f82f29b2a7799d073e04360fd74af955f039114f13b402efc7384749f685cba"
    sha256 cellar: :any, monterey:       "8172589d03993b1cc3e1d4fced3d8f4823b789eec0b3c809fdb3c782edc8471e"
    sha256               x86_64_linux:   "9fe1896a3501706d38ade37b946b50c6465e85154ccc3bc65db86ecb93ea3366"
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
