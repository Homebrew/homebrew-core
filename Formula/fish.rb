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

  pour_bottle? only_if: :default_prefix

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "247f2bf1fa3869cee18bf44bc5982841d7a704468165534ca79b3b45970b7c14"
    sha256 cellar: :any,                 arm64_monterey: "13e8e8cbb8dff7100071fa3c6b6ac1c8020391bebb6ee6bc09a30f6596b745b6"
    sha256 cellar: :any,                 arm64_big_sur:  "b89a98ad4bd08705fa846414067b107108306ae7ad8b36262c4ea1f2de416ebc"
    sha256 cellar: :any,                 ventura:        "a67cffd23c641079a2745ec866e189984a43588256dfcc15eac398babccc18c1"
    sha256 cellar: :any,                 monterey:       "0586d93e70fdf0fdc28f9043f95fb64034fb1b2bca6d02a4dbc8e18b0c057057"
    sha256 cellar: :any,                 big_sur:        "d5af21044ac5b8974411fed9b51ffaad19410194f14a78c4545a9d5b836de0c9"
    sha256 cellar: :any,                 catalina:       "a071642cc6bcc7e5297775f4a7b702388e6b34aa22a1beb348f765f2eb6c0c9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8ed12388a0f26f7f242efdd492e9f439e4a5cff0167f6e22c26ca1b44d11dbd"
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", branch: "master"

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
