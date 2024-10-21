class Libdex < Formula
  desc "Future-based programming for GLib-based applications"
  homepage "https://gitlab.gnome.org/GNOME/libdex"
  url "https://gitlab.gnome.org/GNOME/libdex/-/archive/0.8.1/libdex-0.8.1.tar.gz"
  sha256 "52b502ec163a08c96a557c0d1f6ac32bd15a2e135cef879d3b4cfd06b352b6a7"
  license "LGPL-2.1-or-later"
  head "https://gitlab.gnome.org/GNOME/libdex.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "df7c6ac48592f053e01b0cfe782c38385504ecd6b3e4c26e8bfb59cf7cac6a4a"
    sha256 cellar: :any,                 arm64_sonoma:  "1023595e5fbcd3248ca0f1fe41fa0fbb613671b7fa358532f41e809a0a9aa880"
    sha256 cellar: :any,                 arm64_ventura: "ed78a1cac0485787549dc48dea4110a4748be44ce3486520dd02c7109b3c47b5"
    sha256 cellar: :any,                 sonoma:        "7570ad7ab98809ff45008b55fb8dab4696e4a303c483822189cd7a7235a1df86"
    sha256 cellar: :any,                 ventura:       "b0b29b7ec0a4a6c0b87073a66e2363530fe2eeb9cf24d4a24ae0f6fb0b6718a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aaf0c0e625cd495cb6b2a357d16ea2017b176763d1dc3c2aca6bd96cd56ccca"
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
