class Dc3dd < Formula
  desc "Patched GNU dd that is intended for forensic acquisition of data"
  homepage "https://sourceforge.net/projects/dc3dd/"
  url "https://downloads.sourceforge.net/project/dc3dd/dc3dd/7.3.1/dc3dd-7.3.1.zip"
  sha256 "bd1b66d20a4020ab94b512e56d76cb5f86470d0216081586d596366927cb8d8b"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "1319a1907495f80e22c8e4047ff2a3764821774313b674853ac89f0f95159c1d"
    sha256 arm64_sequoia:  "1cdfecc59688663ad056a3dc3db19a87d5e7c6356f9f88c33695126b0270639c"
    sha256 arm64_sonoma:   "31e4adf9ec3c885a693cc149e6319e6ca2b4e8af140a4b72c6a537196daa2e21"
    sha256 arm64_ventura:  "e0f138b256f063d582d624d041ff18933e3cdec9921cbea06b4500f766a6a2cf"
    sha256 arm64_monterey: "f77cd62b64d5ae2680254fd0568f82a5cc86afe8340d9cf523b54e88c9ad1f26"
    sha256 arm64_big_sur:  "a4f247d8b8f6f68e697c325989fd79d1c019e7d8babcbd48d0327480a676c43b"
    sha256 sonoma:         "45804b97f88239ae78085257aee9c32a397e183d8f83035cd84d0a8fb4d2aa66"
    sha256 ventura:        "f65cccfafa99f62c687eb87c64cfdb3492f8050e86a268045d73f53f5c5dfe97"
    sha256 monterey:       "b8270f518be57090a150e2d78048b8f2e6a81e16092007e48bef6e5e567a4cf3"
    sha256 big_sur:        "f61a5f9196c0c30c9087d92b22522db1c344137406a3272381add30d49c9621f"
    sha256 arm64_linux:    "f56498b96fad1eb7f15ad686bf19360f92844322299627e0e20c57c3a5d5c219"
    sha256 x86_64_linux:   "bdaae1ff1efcea3319dbf1e84f68c1d51a1b12e8a8eae4c13f2e2069084051c7"
  end

  depends_on "gettext"

  uses_from_macos "perl" => :build

  resource "gettext-pm" do
    url "https://cpan.metacpan.org/authors/id/P/PV/PVANDRY/gettext-1.07.tar.gz"
    sha256 "909d47954697e7c04218f972915b787bd1244d75e3bd01620bc167d5bbc49c15"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", buildpath/"gettext-pm/lib/perl5"
    resource("gettext-pm").stage do
      inreplace "Makefile.PL", "$libs = \"-lintl\"",
                               "$libs = \"-L#{Formula["gettext"].opt_lib} -lintl\""
      system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}/gettext-pm"
      system "make"
      system "make", "install"
    end

    # Fix to error: call to undeclared function 'strtod_l';
    if OS.mac? && DevelopmentTools.clang_build_version >= 1700
      inreplace "lib/c-strtod.c",
                "#include <stdlib.h>",
                "#include <stdlib.h>\n#include <xlocale.h>"
    end

    # Fixes error: 'Illegal instruction: 4'; '%n used in a non-immutable format string' on 10.13
    # Patch comes from gnulib upstream (see https://sourceforge.net/p/dc3dd/bugs/17/)
    inreplace "lib/vasnprintf.c",
              "# if !(__GLIBC__ > 2 || (__GLIBC__ == 2 && __GLIBC_MINOR__ >= 3) " \
              "|| ((defined _WIN32 || defined __WIN32__) && ! defined __CYGWIN__))",
              "# if !(defined __APPLE__ && defined __MACH__)"

    chmod 0555, ["build-aux/install-sh", "configure"]

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --infodir=#{info}
      gl_cv_func_stpncpy=yes
    ]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args
    system "make"
    system "make", "install"
    prefix.install %w[Options_Reference.txt Sample_Commands.txt]
  end

  test do
    system bin/"dc3dd", "--help"
  end
end
