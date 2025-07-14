class LunarDate < Formula
  desc "Chinese lunar date library"
  homepage "https://github.com/yetist/lunar-date"
  url "https://github.com/yetist/lunar-date/releases/download/v3.0.2/lunar-date-3.0.2.tar.xz"
  sha256 "608d6e984d4eadae836706c0099f3721b878506b04e053058f694e9fd93933bc"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_sequoia: "634d979674acaa436cee47c3edf4415e5e968981794e7dfbc68f2c5c752127c0"
    sha256 arm64_sonoma:  "be6e44e2a216af958c79583e1112699f5a63ec5455b51e6f0427907a7d51390f"
    sha256 arm64_ventura: "8b07143441c3dcdc7fcc54ed39f3351a65f3fb81f3ef7702b4f746f2a37c5b91"
    sha256 sonoma:        "a6c02f073c90d347bdf0eb0e54a3abfbd448ae1910be9f867cbb484764efe986"
    sha256 ventura:       "e64cb24b075865917e0649a3e3c991cdd1648837d9b17728f4fef67ed11c9916"
    sha256 arm64_linux:   "b9817d81e38b2153d296cc8b244a3f867ca514ddbb38967dc05a956e7264039a"
    sha256 x86_64_linux:  "42994fbe6ca011c300209f9bf534268e858ec4d5e147063cf3d7dfb4cfb31179"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    pkgshare.install "tests"

    # Fix missing #include <locale.h> in testing.c
    inreplace pkgshare/"tests/testing.c", "#include <stdlib.h>",
      "#include <stdlib.h>\n#include <locale.h>"
  end

  test do
    pkgconf_flags = Utils.safe_popen_read("pkgconf", "--cflags", "--libs", "lunar-date-3.0", "glib-2.0").chomp.split
    system ENV.cc, pkgshare/"tests/testing.c", *pkgconf_flags,
                   "-I#{include}/lunar-date-3.0/lunar-date",
                   "-L#{lib}", "-o", "testing"
    assert_match "End of date tests", shell_output("#{testpath}/testing")
  end
end
