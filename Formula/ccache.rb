class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https://ccache.dev/"
  url "https://github.com/ccache/ccache/releases/download/v4.8/ccache-4.8.tar.xz"
  sha256 "b963ee3bf88d7266b8a0565e4ba685d5666357f0a7e364ed98adb0dc1191fcbb"
  license "GPL-3.0-or-later"
  head "https://github.com/ccache/ccache.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1256f221c0db2dce9111077378a386c31aae88e030882ea4890da8bb9a15aa76"
    sha256 cellar: :any,                 arm64_monterey: "18f910678dd3c957307423cf70fd637364be509138c386b2aee817efbd933a82"
    sha256 cellar: :any,                 arm64_big_sur:  "5ad50d725a25c3438dda4d9f29e0338eb45402d0f02578fe96a0b8b30f2db65e"
    sha256 cellar: :any,                 ventura:        "36c1d3385e5b5fd734f5b75e7224bdd8171e86a333b7b69c76bdbe7a7f795883"
    sha256 cellar: :any,                 monterey:       "50e5c9744229a7bc4da0467f7b4348d3b671b4deded2ff9cfd801ca48ebe5aa1"
    sha256 cellar: :any,                 big_sur:        "85f2346f9e95a3befa6f58a9b4085b2aa3049a1894529947a1f19eb4000ebcfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfb0da0d60457bd690022fa805d1af86ac69b8bcf1061f3f5ae9f031f161250f"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "hiredis"
  depends_on "zstd"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_IPO=TRUE"
    system "cmake", "--build", "build"

    # Homebrew compiler shim actively prevents ccache usage (see caveats), which will break the test suite.
    # We run the test suite for ccache because it provides a more in-depth functional test of the software
    # (especially with IPO enabled), adds negligible time to the build process, and we don't actually test
    # this formula properly in the test block since doing so would be too complicated.
    # See https://github.com/Homebrew/homebrew-core/pull/83900#issuecomment-90624064
    with_env(CC: DevelopmentTools.locate(DevelopmentTools.default_compiler)) do
      system "ctest", "-j#{ENV.make_jobs}", "--test-dir", "build"
    end

    system "cmake", "--install", "build"

    libexec.mkpath

    %w[
      clang
      clang++
      cc
      gcc gcc2 gcc3 gcc-3.3 gcc-4.0
      gcc-4.2 gcc-4.3 gcc-4.4 gcc-4.5 gcc-4.6 gcc-4.7 gcc-4.8 gcc-4.9
      gcc-5 gcc-6 gcc-7 gcc-8 gcc-9 gcc-10 gcc-11 gcc-12
      c++ c++3 c++-3.3 c++-4.0
      c++-4.2 c++-4.3 c++-4.4 c++-4.5 c++-4.6 c++-4.7 c++-4.8 c++-4.9
      c++-5 c++-6 c++-7 c++-8 c++-9 c++-10 c++-11 c++-12
      g++ g++2 g++3 g++-3.3 g++-4.0
      g++-4.2 g++-4.3 g++-4.4 g++-4.5 g++-4.6 g++-4.7 g++-4.8 g++-4.9
      g++-5 g++-6 g++-7 g++-8 g++-9 g++-10 g++-11 g++-12
      i686-w64-mingw32-gcc i686-w64-mingw32-g++
      x86_64-w64-mingw32-gcc x86_64-w64-mingw32-g++
    ].each do |prog|
      libexec.install_symlink bin/"ccache" => prog
    end
  end

  def caveats
    <<~EOS
      To install symlinks for compilers that will automatically use
      ccache, prepend this directory to your PATH:
        #{opt_libexec}

      If this is an upgrade and you have previously added the symlinks to
      your PATH, you may need to modify it to the path specified above so
      it points to the current version.

      NOTE: ccache can prevent some software from compiling.
      ALSO NOTE: The brew command, by design, will never use ccache.
    EOS
  end

  test do
    ENV.prepend_path "PATH", opt_libexec
    assert_equal "#{opt_libexec}/gcc", shell_output("which gcc").chomp
    system "#{bin}/ccache", "-s"
  end
end
