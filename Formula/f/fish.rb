class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/4.0.2/fish-4.0.2.tar.xz"
  sha256 "6e1ecdb164285fc057b2f35acbdc20815c1623099e7bb47bbfc011120adf7e83"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256                               arm64_sequoia: "1ac7c928f8d48a68e5e80ab7bf666f699645df013e1a3cc587001a515d52785e"
    sha256                               arm64_sonoma:  "e1bec377cb41fd1bb725c3dab2d857fc66b04539324c8243a6b5b5801eb4e8e2"
    sha256                               arm64_ventura: "97ca9b5de161d65358a7fd965265ff74d26f43b4324332e124a82347a0045620"
    sha256                               sonoma:        "fcf5a0407c0659f60c7c805aa25194a244b24b7b1f5cb7fd213ef802ef520982"
    sha256                               ventura:       "0f73e4a50d3ca051cbcadf83d56a97f18a3dbe77abd0946506a2f0d2a9bc291c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "932f72231071f518ab3878271c8e68802b8bf1ad0ac50546f7839bf7dd37ac9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76bcf456adfac4399b55a5ea5e7f37b4f82bcfa6e38d2c513de2037308980abd"
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
