class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.5.1/fish-3.5.1.tar.xz"
  sha256 "a6d45b3dc5a45dd31772e7f8dfdfecabc063986e8f67d60bd7ca60cc81db6928"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dff640f596dc1323b592a35b618536ae267ad69703c2af39b94ea8c9db6e1e43"
    sha256 cellar: :any,                 arm64_big_sur:  "0a5cfb7cd0897201505debd51948229fa77fae5ed9b332bfaee521d443d24dc9"
    sha256 cellar: :any,                 monterey:       "c3ba6fdea61a807981740ba74cdf3376b802834dbe8a00dcc6421fed223c860f"
    sha256 cellar: :any,                 big_sur:        "5ab3659327587673ac57da418180e81eaf65570c62cfa62b788a019dcb3d9256"
    sha256 cellar: :any,                 catalina:       "1b78a9fb61874bb471188834884705ee7a15b9d35f5760a44e0c388feb9e62ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5ee59f9f54cec475f7f4665f97cce74157b51119d4ff10c723519d4cdc4caa4"
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git"

    depends_on "sphinx-doc" => :build
  end

  depends_on "cmake" => :build
  # Apple ncurses (5.4) is 15+ years old and
  # has poor support for modern terminals
  depends_on "ncurses"
  depends_on "pcre2"

  def install
    args = %W[
      -Dextra_functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d
      -Dextra_completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d
      -Dextra_confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
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
