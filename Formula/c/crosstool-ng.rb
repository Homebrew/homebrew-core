class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "https://crosstool-ng.github.io/"
  url "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.28.0.tar.xz"
  sha256 "5750e29a2bda5cd8d67900592576b1670a1987a4dcd5e4f6beae09138a1f5699"
  license "GPL-2.0-only"
  head "https://github.com/crosstool-ng/crosstool-ng.git", branch: "master"

  livecheck do
    url "https://crosstool-ng.github.io/download/"
    regex(/href=.*?crosstool-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a4d557d0df32e98fc22392b385606bc8828b429ea5b39d1d2758cccef28cad41"
    sha256 cellar: :any,                 arm64_sequoia: "78e4a8a9d682a7a386b9f004659224cbdbe5c203ef13e8758a2e1d4d96a39cc9"
    sha256 cellar: :any,                 arm64_sonoma:  "8c1d2f4a583a5d000dadbbaf7dc2b3f79407519096674cac0fc346cc657f8a03"
    sha256 cellar: :any,                 arm64_ventura: "2460d7593c74deef19b24f77308b20df82215ffa6883da1090f78029552d089a"
    sha256 cellar: :any,                 sonoma:        "e532d84a86dca103c52eaa7b81e849aa8e01b3f7ee1aace68bcd898ac83fbe15"
    sha256 cellar: :any,                 ventura:       "6e19b2a37a74e049d8b89000a9bf482f0ca0d1bf626f9f1c9a5177380f81ac60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00ea8cfb14b72d15f3b80acdf211be93d841c1e4ca498e82060c47e17d2d8746"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4403910ecef81e3775f83a830c6505289312770332cc2dc4f0a978357b689764"
  end

  depends_on "help2man" => :build
  depends_on "autoconf"
  depends_on "automake"
  depends_on "binutils"
  depends_on "bison"
  depends_on "flex"
  depends_on "libtool"
  depends_on "lzip"
  depends_on "m4"
  depends_on "ncurses"
  depends_on "python@3.13"
  depends_on "xz"

  uses_from_macos "flex" => :build
  uses_from_macos "gperf" => :build
  uses_from_macos "unzip" => :build

  on_macos do
    depends_on "bash"
    depends_on "coreutils"
    depends_on "gawk"
    depends_on "gettext"
    depends_on "gnu-sed"
    depends_on "grep"
    depends_on "make"
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "./bootstrap" if build.head?

    ENV["BISON"] = Formula["bison"].opt_bin/"bison"
    ENV["M4"] = Formula["m4"].opt_bin/"m4"
    ENV["PYTHON"] = Formula["python@3.13"].opt_bin/"python3.13"

    if OS.mac?
      ENV["MAKE"] = Formula["make"].opt_bin/"gmake"
      ENV.append "LDFLAGS", "-lintl"
    else
      ENV.append "CFLAGS", "-I#{Formula["ncurses"].include}/ncursesw"
    end

    system "./configure", "--prefix=#{prefix}"

    # Must be done in two steps
    system "make"
    system "make", "install"

    inreplace [bin/"ct-ng", pkgshare/"paths.sh"], Superenv.shims_path/"gmake", "gmake" unless OS.mac?
  end

  test do
    assert_match "This is crosstool-NG", shell_output("make -rf #{bin}/ct-ng version")
  end
end
