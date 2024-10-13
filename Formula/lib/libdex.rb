class Libdex < Formula
  desc "Future-based programming for GLib-based applications"
  homepage "https://gitlab.gnome.org/GNOME/libdex"
  url "https://gitlab.gnome.org/GNOME/libdex/-/archive/0.8.0/libdex-0.8.0.tar.gz"
  sha256 "4d213cda9432e05c7d8c3e8aa844d5357966d7aec5ff7e351661d6aaab0d107c"
  license "LGPL-2.1-or-later"
  head "https://gitlab.gnome.org/GNOME/libdex.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "90f1a3c13f23736f73ce0789786831d7c9601d8b356f28a8a9e5854585abd51d"
    sha256 cellar: :any,                 arm64_sonoma:  "eed9f949f89c1320de99270b6e068e0e961cb220b65f772bc1d8d46727a5ae85"
    sha256 cellar: :any,                 arm64_ventura: "83129eb405194ffdd455e350b5ea3a264e95f67e80cad93383647388e5e2555b"
    sha256 cellar: :any,                 sonoma:        "87dc37d4cd9c899ecea51cae9ad51308d3fb532c6ec4f2b5b6fbc2f4358c9c88"
    sha256 cellar: :any,                 ventura:       "468fbeb9589c1341484cf4ea12a5924b396356b2fbb2acfde35fa8a2eede65da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3ea4e1a78f97c13eca1e1fa59aecfc668876730a8d01c96af363892cd64c2e4"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build # for vapigen
  depends_on "glib"

  def install
    system "meson", "setup", "build", "-Dexamples=false", "-Dsysprof=false", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "examples", "build/config.h"
  end

  test do
    cp %w[examples/cp.c config.h].map { |file| pkgshare/file }, "."

    ENV.append_to_cflags "-I."
    ENV.append_to_cflags shell_output("pkg-config --cflags libdex-1").chomp
    ENV.append "LDFLAGS", shell_output("pkg-config --libs-only-L libdex-1").chomp
    ENV.append "LDLIBS", shell_output("pkg-config --libs-only-l libdex-1").chomp

    system "make", "cp"

    text = Random.rand.to_s
    (testpath/"test").write text
    system "./cp", "test", "not-test"
    assert_equal text, (testpath/"not-test").read
  end
end
