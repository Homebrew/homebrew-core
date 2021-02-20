class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "https://crosstool-ng.github.io/"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.24.0.tar.xz"
  sha256 "804ced838ea7fe3fac1e82f0061269de940c82b05d0de672e7d424af98f22d2d"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/crosstool-ng/crosstool-ng.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6b511659323ff03bd405c20e8591cacb55dbb081fe8f2416666228d9ed4cf1a8"
    sha256 cellar: :any, big_sur:       "179cfc5008cbff1c21aba36ba14a9fb76e927035bf2554cdd0761382d70e58ca"
    sha256 cellar: :any, catalina:      "77abb4c65e4eeabbc3300464367462c9342b6b4a6aa2342d6f92c6a682f91dd9"
    sha256 cellar: :any, mojave:        "897d58874abdcf5dd4b7e606e8996f16255a996f53df29ff9dfcc2774ca5ef22"
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
  depends_on "ncurses"
  depends_on "python@3.9"
  depends_on "xz"

  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "texinfo" => :build
  uses_from_macos "unzip" => :build

  def install
    system "./bootstrap" if build.head?

    ENV["BISON"] = "#{Formula["bison"].opt_bin}/bison"
    ENV["M4"] = "#{Formula["m4"].opt_bin}/m4"
    ENV["MAKE"] = "#{Formula["make"].opt_bin}/gmake"
    ENV["PYTHON"] = "#{Formula["python@3.9"].opt_bin}/python3"
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
