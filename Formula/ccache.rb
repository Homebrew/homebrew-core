class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https://ccache.dev/"
  url "https://github.com/ccache/ccache/releases/download/v4.7/ccache-4.7.tar.xz"
  sha256 "d9283bbe22085268f52d309b91adb81a77a7abe10867eb6852057910ffac736a"
  license "GPL-3.0-or-later"
  head "https://github.com/ccache/ccache.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "8c50c39d13b54619bb43992bf66bc3940e7e9febb482e934358500ca7dd1e7ca"
    sha256 cellar: :any,                 arm64_big_sur:  "43c052adee9202f5570310ee899fcfcb84a0e33cba53551ed0dbefd80e8c7571"
    sha256 cellar: :any,                 monterey:       "01b164dced909769afa9d5d155561d4a56ebf65ba816c1273a3fc9d2ebb29b8d"
    sha256 cellar: :any,                 big_sur:        "583772a305a9c123cb8a7fa5932be0570aba9a3a4a7e20dc31e6635f1b3352b3"
    sha256 cellar: :any,                 catalina:       "8a567f743ae7c9a3ee741565e9391df3cb767755d2fcd089bde5b17d9c9bb981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed275c3781149bfd2140ee84ee7d78bcd96f725f0aceb152495469511e3357eb"
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
