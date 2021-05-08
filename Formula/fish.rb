class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.2.2/fish-3.2.2.tar.xz"
  sha256 "5944da1a8893d11b0828a4fd9136ee174549daffb3d0adfdd8917856fe6b4009"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f5c944adf3c809bb40601157c0879e7c1425e515d1eb94b262c8e2df58d91855"
    sha256 cellar: :any, big_sur:       "3b580443ffe91b87d60d7bb5a85493a138fe6d731ac883f0769d6b06e1cb9a76"
    sha256 cellar: :any, catalina:      "150c9da4f2786cee5a8da6e5988b14f42213b2d3f051038f223c4986253d6d61"
    sha256 cellar: :any, mojave:        "04a1913039b23d096c7ed2481fdfb55f0cf16cb69761aaf85eff65095a1bdf7d"
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", shallow: false

    depends_on "sphinx-doc" => :build
  end

  depends_on "cmake" => :build
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
