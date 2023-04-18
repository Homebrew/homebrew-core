class LunarDate < Formula
  desc "Chinese lunar date library"
  homepage "https://github.com/yetist/lunar-date"
  url "https://github.com/yetist/lunar-date/releases/download/v3.0.1/lunar-date-3.0.1.tar.xz"
  sha256 "de00cf81fc7a31c08ea679c4a876dd6d4ea661b33bb8c192bbc016e8f3e16aca"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_ventura: "19aff5df6a94c6367cefb6e970257d1533c6db1d7159f2ae8c1e0ec295ac9cbb"
    sha256 arm64_big_sur: "17475cd85977801b5ea3cb71e51329ed3ac322eb97c6109fd8c9d9addc44f07e"
    sha256 ventura:       "f8990a85edb14b45e4819764856acd9dbb78960fc03557e40aacebdd23e8f1fb"
    sha256 monterey:      "fab352d50cf04dbb5f4048a7b2af595070bc0b45d0cfd0b5b9a23f39a875e523"
    sha256 big_sur:       "70f91a1f90710f781fdb99875b6e35d7b54f6be0b9e084ebab3ad6bd5b3a41a9"
    sha256 catalina:      "d1b8c963d4e48947c6d10aa04e18bd3775d117da648193c04f8207e77a606c62"
    sha256 x86_64_linux:  "0fd076e291a5801cc977b8adc505e9cc279302bbedd4a62ba69166698c2166a6"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    pkgshare.install "tests"

    # Fix missing #include <locale.h> in testing.c
    inreplace pkgshare/"tests/testing.c", "#include <stdlib.h>",
      "#include <stdlib.h>\n#include <locale.h>"
  end

  test do
    pkg_config_flags = Utils.safe_popen_read("pkg-config", "--cflags", "--libs", "lunar-date-3.0",
"glib-2.0").chomp.split
    system ENV.cc, pkgshare/"tests/testing.c", *pkg_config_flags,
                   "-I#{include}/lunar-date-3.0/lunar-date",
                   "-L#{lib}", "-o", "testing"
    assert_match "End of date tests", shell_output("#{testpath}/testing")
  end
end
