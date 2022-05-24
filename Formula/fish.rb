class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.4.1/fish-3.4.1.tar.xz"
  sha256 "b6f23b3843b04db6b0a90fea1f6f0d0e40cc027b4a732098200863f2864a94ea"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "34bcdd4310da2fe6e5e4d31ef465bdc38bb403ac050dd8efacfc9dcf35b451d7"
    sha256 cellar: :any,                 arm64_big_sur:  "e4e1c8f1235b462cd1f5f21e59be0f8dce7e075f95d6fe2138d363f3957c0601"
    sha256 cellar: :any,                 monterey:       "2af22ec016e21463326a33c653dc8c66d56deff1f975c8753a6ec2df894e0c17"
    sha256 cellar: :any,                 big_sur:        "5e775df994cdd2479aec83c91fa103f883317e515429e18e57cea0a5de992cde"
    sha256 cellar: :any,                 catalina:       "295d2223a3f98c4cbaeeb465480651db830e9be270834356d50fd4da3b9bc874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "126ef47d281af27b490e74c8f89e210bc418f8e3cf6e0eea58228fbd0a8076fd"
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
