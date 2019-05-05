class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "https://crosstool-ng.github.io/"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.24.0.tar.xz"
  sha256 "804ced838ea7fe3fac1e82f0061269de940c82b05d0de672e7d424af98f22d2d"
  head "https://github.com/crosstool-ng/crosstool-ng.git"

  bottle do
    cellar :any
    sha256 "ff4b4bac28f1bbdf6abff9cc6f4b2922f03714c45744d4eb8a9ab0cf43431f2f" => :mojave
    sha256 "bfefcefca16704e4431de7641e898fa0a5b41c003cf47351c425d800add5d624" => :high_sierra
    sha256 "d07f5ec5998c68035dac51044fbb213b02f07670f9d156facbb64756f5034330" => :sierra
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
    if build.head?
      system "./bootstrap"
    end

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
