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
    sha256 cellar: :any, arm64_tahoe:   "60b6e1d5801ced496f0af8471dbc6bd753483d2a019ffbb48386b4d7497acc36"
    sha256 cellar: :any, arm64_sequoia: "3f7d002bf6b642bc5cbb7aeed1f9e653165d12cfa18e1bdb6485d766be4881a3"
    sha256 cellar: :any, arm64_sonoma:  "235a6fba5185928ed681261c55879b4842430e3a0fff1d13af33d4b947e5ece1"
    sha256 cellar: :any, sonoma:        "7851eaded2360e433afddcb138ae6f5f4326fbe4b8eea998d545160fc0353238"
    sha256 cellar: :any, arm64_linux:   "479436440edb6c2fa91cb3744ae3896c4aea6a0d7df5a6368bda162ac03e85f3"
    sha256 cellar: :any, x86_64_linux:  "607ecdd7d841f9269741316b0dc452c67e738600743241e63af5ad830a678200"
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
  depends_on "python@3.14"
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
