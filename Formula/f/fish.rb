class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/4.0.6/fish-4.0.6.tar.xz"
  sha256 "125d9ce0dd8a3704dc0782925df34f0208bffc42af5f34914449d14c34b5dae1"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256                               arm64_tahoe:   "0578ba2bf7118c9dc8c61c72f9f5d2aca1ee3151d297244b6cde6faee576680d"
    sha256                               arm64_sequoia: "b3d13561b06761af6ebdcfc744b22d27b69dfa0a3b7910f08a63541af4717b0d"
    sha256                               arm64_sonoma:  "cf3564c7d104066440fa8f9f6365c14d6252ad057393005d81457bd1a2767d2a"
    sha256                               sonoma:        "f9740b35d347d72e94237851bf88b028ae821bc444dc3796fadac379b2d9becb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf8ec7a8d81a6014979a11b4ab6d47329b1ae413764c34dae7489ba4883a9784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84a4f715ce1cdce1948ed64bc4d878a80a67d2f8903965ec5418848e0b6424b2"
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", branch: "master"

    depends_on "sphinx-doc" => :build
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  # Apple ncurses (5.4) is 15+ years old and
  # has poor support for modern terminals
  # The library itself is not needed, but the terminfo database is
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
