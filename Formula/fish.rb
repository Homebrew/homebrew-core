class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.6.0/fish-3.6.0.tar.xz"
  sha256 "97044d57773ee7ca15634f693d917ed1c3dc0fa7fde1017f1626d60b83ea6181"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b7cfa15ddc6d68c2c4c76d7b1c5b1b9925e7c312893cd6495e7e4a55189293db"
    sha256 cellar: :any,                 arm64_monterey: "059122804525146dc81a24ae04e2f48367f4f6689c7841d3425f7779faec6dfa"
    sha256 cellar: :any,                 arm64_big_sur:  "2ed86a252b527d7dbd2fa49c9ec50de2840d84d3eb541c9dc7a57a6a6c53865a"
    sha256 cellar: :any,                 ventura:        "aeb45cbbf3a2651936a2d947e8f88d7dc3b9c967f4240e1bc8db244c96f68af8"
    sha256 cellar: :any,                 monterey:       "f0264928c8d313c0c2e41421d5c75ff964ca530db324168138441adcd7a0348e"
    sha256 cellar: :any,                 big_sur:        "d653f23d4037db777262dd1bdf3a1e5710483be080132a56213eaecd98ea995d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e2476caac96faa299f1b474ad8970ab7bc71c0498e1357ffd7a4ace93e802b1"
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
    system "#{bin}/fish", "-c", "echo"
  end
end
