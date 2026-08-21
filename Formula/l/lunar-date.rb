class LunarDate < Formula
  desc "Chinese lunar date library"
  homepage "https://github.com/yetist/lunar-date"
  url "https://github.com/yetist/lunar-date/releases/download/v3.2.0/lunar-date-3.2.0.tar.xz"
  sha256 "2d24263803c0d8ed90c7d68bb7f69a481441f0b3ed89b5a29ea704dea86a4580"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_tahoe:   "005e5459270f8efeecc47feb44febaba493feb7ec70e22b612cf83e76205bac7"
    sha256 arm64_sequoia: "1aeae6259aafeb0cc9e04a470aaa1b2a1ffba3af02298b15f671f2df01c76399"
    sha256 arm64_sonoma:  "216d31cd16d53bb596845c8f1b163e362f9ad6f5a79415c52efe3569b76384a3"
    sha256 sonoma:        "a9e331ff9b9f2798d5ac4d7ff2d6677a5b340c68f0283e262dffe5ade0cd5a87"
    sha256 arm64_linux:   "4d9617dc518794123f349cf741c246d0d531429bf1e89c21cc25e568a3463462"
    sha256 x86_64_linux:  "c1af9894bed16824ff54efccdf76e700c335e3ae1a6f949d9dce419ad7fb9028"
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
