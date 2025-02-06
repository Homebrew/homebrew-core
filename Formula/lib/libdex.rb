class Libdex < Formula
  desc "Future-based programming for GLib-based applications"
  homepage "https://gitlab.gnome.org/GNOME/libdex"
  url "https://gitlab.gnome.org/GNOME/libdex/-/archive/0.9.0/libdex-0.9.0.tar.gz"
  sha256 "c4da72a9215dc30e51c7ca17be169233e26ed56298645c28445d0da71e69aec2"
  license "LGPL-2.1-or-later"
  head "https://gitlab.gnome.org/GNOME/libdex.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fd7e47eec144b2219e9fa13736ca950a43b79e6ea75133baee8371f810733a5a"
    sha256 cellar: :any,                 arm64_sonoma:  "0e8fddeff33873f745286c9aada0b6d16d789716bbb39ffbee9260d778b7940f"
    sha256 cellar: :any,                 arm64_ventura: "26bf1efaa77e5feb426a0f9c5d4d875b547dcea3655731fdfcce3c2d703ddb6d"
    sha256 cellar: :any,                 sonoma:        "ff91f2e1c9d9d86ca4ebf64540ccc5e9109e2a0282039e723f36f4ad9be0f817"
    sha256 cellar: :any,                 ventura:       "1ebe34a708a5f6059dfbeb8bbb774e11971fac8b9b074111b2ed74ad0b2a508b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5665f555b8598f23ab43594e38e587dd195337ebb5c09aa12713622d1e5f2e91"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
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
    ENV.append_to_cflags shell_output("pkgconf --cflags libdex-1").chomp
    ENV.append "LDFLAGS", shell_output("pkgconf --libs-only-L libdex-1").chomp
    ENV.append "LDLIBS", shell_output("pkgconf --libs-only-l libdex-1").chomp

    system "make", "cp"

    text = Random.rand.to_s
    (testpath/"test").write text
    system "./cp", "test", "not-test"
    assert_equal text, (testpath/"not-test").read
  end
end
