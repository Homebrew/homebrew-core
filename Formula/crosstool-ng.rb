class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "https://crosstool-ng.github.io/"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.24.0.tar.xz"
  sha256 "804ced838ea7fe3fac1e82f0061269de940c82b05d0de672e7d424af98f22d2d"
  revision 1
  head "https://github.com/crosstool-ng/crosstool-ng.git"

  bottle do
    cellar :any
    sha256 "733a1e37563ffd06a187fdad312bb03e1eca1467832771b57141b4542b81464a" => :catalina
    sha256 "f95cc7d4b3bfcc8584d89c5dfa11d39e246c36ca2d707b108d5330fe24ac41c7" => :mojave
    sha256 "c7f30be654aece34ce9e7cf5fc08f745cad233ff11ad1fd81826d9344a22345b" => :high_sierra
    sha256 "b4d034ebac32df3affdd139f4c49804b74216bf372a9831c01693220d442a39a" => :sierra
  end

  depends_on "help2man" => :build
  depends_on "autoconf"
  depends_on "automake"
  depends_on "bash"
  depends_on "binutils"
  depends_on "bison"
  depends_on "coreutils"
  depends_on "flex"
  depends_on "gawk"
  depends_on "gettext"
  depends_on "gnu-sed"
  depends_on "grep"
  depends_on "libtool"
  depends_on "lzip"
  depends_on "m4"
  depends_on "make"
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "xz"

  def install
    system "./bootstrap" if build.head?

    ENV["BISON"] = "#{Formula["bison"].opt_bin}/bison"
    ENV["M4"] = "#{Formula["m4"].opt_bin}/m4"
    ENV["MAKE"] = "#{Formula["make"].opt_bin}/gmake"
    ENV.append "LDFLAGS", "-lintl"

    system "./configure", "--prefix=#{prefix}"

    # Must be done in two steps
    system "make"
    system "make", "install"
  end

  test do
    assert_match "This is crosstool-NG", shell_output("make -rf #{bin}/ct-ng version")
  end
end
