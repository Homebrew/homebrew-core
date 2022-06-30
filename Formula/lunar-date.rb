class LunarDate < Formula
  desc "Chinese lunar date library"
  homepage "https://github.com/yetist/lunar-date"
  url "https://github.com/yetist/lunar-date/releases/download/v3.0.1/lunar-date-3.0.1.tar.xz"
  sha256 "de00cf81fc7a31c08ea679c4a876dd6d4ea661b33bb8c192bbc016e8f3e16aca"
  license "LGPL-2.1-or-later"

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
