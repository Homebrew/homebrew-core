class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "https://crosstool-ng.github.io/"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.24.0.tar.xz"
  sha256 "804ced838ea7fe3fac1e82f0061269de940c82b05d0de672e7d424af98f22d2d"
  license "GPL-2.0-only"
  revision 3
  head "https://github.com/crosstool-ng/crosstool-ng.git", branch: "master"

  livecheck do
    url "https://crosstool-ng.github.io/download/"
    regex(/href=.*?crosstool-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "928ab5b65f02d60d2d5d3216b56f9fce9f3231ef7bac30641539936240baf8f6"
    sha256 cellar: :any, arm64_big_sur:  "254e9876927261a6efc043b3e856efc9c03950dd12e54be66924dd4653683a78"
    sha256 cellar: :any, monterey:       "11cdeefd6ff97a4d2c3e71f036589381aa7311efe095509490abfb4dcf729b44"
    sha256 cellar: :any, big_sur:        "6955331d9b2ba412d96239337c8a46630c351f9081f0193607d89939ac38c66e"
    sha256 cellar: :any, catalina:       "162c6baa79fd3f140e750d6ec65273c4e9f3b48b82f491937dd53b5debd21a89"
    sha256 cellar: :any, mojave:         "d0fbd991dd2862f0edeca38ecc360743f78d0d67ec9b4ad41e3a4b2949b39acd"
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
  depends_on "python@3.10"
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
    ENV["PYTHON"] = "#{Formula["python@3.10"].opt_bin}/python3"
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
