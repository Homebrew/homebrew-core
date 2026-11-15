class CrosstoolNg < Formula
  desc "Tool for building toolchains"
  homepage "https://crosstool-ng.github.io/"
  url "https://github.com/crosstool-ng/crosstool-ng/releases/download/crosstool-ng-1.29.0/crosstool-ng-1.29.0.tar.xz"
  sha256 "1e0c5efcf2af674993b74a1783fe78727c8d34b500ebab07eb1bb0a45c8fcc87"
  license "GPL-2.0-only"
  head "https://github.com/crosstool-ng/crosstool-ng.git", branch: "master"

  livecheck do
    url "https://crosstool-ng.github.io/download/"
    regex(/href=.*?crosstool-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "68c7ffab95388303d7d4c4fb22e434929987d171cc74abe3e65b4cfb61de5514"
    sha256 cellar: :any, arm64_tahoe:       "23e2acff54566c0a6f06bcec2aad942904aec1120b7dd8dc33dce8905ed996a9"
    sha256 cellar: :any, arm64_sequoia:     "6c86a6ff8e127ee0bed435f09abbfd11b06139055215cec83b0fd0ac9361b9d5"
    sha256 cellar: :any, arm64_linux:       "4ff722a9ee61a81cbe2538f850c97f114b05a2a74dded7b7a1e4c722b6c5ad89"
    sha256 cellar: :any, x86_64_linux:      "a2060b2e8e94be69af3d2c094470507efb0ff507acc4fe5187248314db871f53"
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
  depends_on "python@3.15"
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

    ENV["BISON"] = formula_opt_bin("bison")/"bison"
    ENV["M4"] = formula_opt_bin("m4")/"m4"
    ENV["PYTHON"] = python3

    if OS.mac?
      ENV["MAKE"] = formula_opt_bin("make")/"gmake"
      ENV.append "LDFLAGS", "-lintl"
    else
      ENV.append "CFLAGS", "-I#{formula_opt_include("ncurses")}/ncursesw"
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
