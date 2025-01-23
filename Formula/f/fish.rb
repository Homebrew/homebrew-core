class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.7.1/fish-3.7.1.tar.xz"
  sha256 "614c9f5643cd0799df391395fa6bbc3649427bb839722ce3b114d3bbc1a3b250"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6f00c494ab15af26f19ec21c2ca954b3870d400d8b22203a5bf7f1cf86465570"
    sha256 cellar: :any,                 arm64_sonoma:   "479ae1960544dc4a84c961f125bb9cc42c194ec2a04f0ffb1591e0c3c1d7d577"
    sha256 cellar: :any,                 arm64_ventura:  "51719eb992cbea31b99828036479b510011c1b4eef131a7b684bf4835f01374e"
    sha256 cellar: :any,                 arm64_monterey: "0261f26bf449353f84f83ebfe3922fb2d6a0f98e65c551f3d3b14d0e26e78723"
    sha256 cellar: :any,                 sonoma:         "a5b25fde2926a00b08d77798c52030543252418733442fc25eb1e0ce99b95010"
    sha256 cellar: :any,                 ventura:        "f2d8ddb5b5e4a29dc9e39230845b514c9fc169e5f2922a1369bd72decc141886"
    sha256 cellar: :any,                 monterey:       "8518a301b9136ecbd87373b39c6736fae1fc0569da2fa8be7d5f066f1b320fd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c69075343a17848c5f56d4af091e84604f7447fd91d62ebd92ce20b9eb67f2b5"
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", branch: "master"

    depends_on "rust" => :build
    depends_on "sphinx-doc" => :build
  end

  depends_on "cmake" => :build
  # Apple ncurses (5.4) is 15+ years old and
  # has poor support for modern terminals
  depends_on "ncurses"
  depends_on "pcre2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-Dextra_functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d",
                    "-Dextra_completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d",
                    "-Dextra_confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (pkgshare/"vendor_functions.d").mkpath
    (pkgshare/"vendor_completions.d").mkpath
    (pkgshare/"vendor_conf.d").mkpath
  end

  test do
    system bin/"fish", "-c", "echo"
  end
end
