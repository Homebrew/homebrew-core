class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/refs/tags/0.5.6.tar.gz"
  sha256 "68cb4548143e843826a35e024dba8ced92117c0982c2cc9a4c8247e32d259603"
  license "LGPL-2.1-or-later"
  head "https://github.com/libproxy/libproxy.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "5f4fdbd879a03610e3f3107632203ed8cb969f43a9fbca64c1531b7753209ce4"
    sha256 cellar: :any, arm64_ventura:  "1a8d5eec483a816346c33474f266740939b06938bf057e7b49afb6ce64b94596"
    sha256 cellar: :any, arm64_monterey: "b4eecda20ee2ad4841f4f73b46bb948e6fc47d18e9b18b501895a6f9fd4c8106"
    sha256 cellar: :any, sonoma:         "d6796927cf5fb887a3184a8e7780902be0b507389be63e092ecac6e2513c3900"
    sha256 cellar: :any, ventura:        "fb26253772d480d419ea945cdb5a3a652c418cf1c2fbb5ee0e9233d4464a9bc3"
    sha256 cellar: :any, monterey:       "8b02f72739715460195280bf3ba87d66bba82c4da57ec1034605ec555009e0c3"
    sha256               x86_64_linux:   "bea15f8c685d247305b5b90a296732f9204e00e04f197c38fa4a371da8a9ab54"
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
