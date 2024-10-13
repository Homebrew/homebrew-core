class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https://ccache.dev/"
  url "https://github.com/ccache/ccache/releases/download/v4.10.2/ccache-4.10.2.tar.xz"
  sha256 "c0b85ddfc1a3e77b105ec9ada2d24aad617fa0b447c6a94d55890972810f0f5a"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/ccache/ccache.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f89e12a721fd48ed3dcfcc3eff8287ba0c1998dda77dab5a29da49611f24d473"
    sha256 cellar: :any,                 arm64_sonoma:   "99a4fa919beefde392d18a2584582573c1da1846a235dd1cb263143ff6d1b7cb"
    sha256 cellar: :any,                 arm64_ventura:  "64ddf5e321d706fc72217b93e1006fce74bd0455d44fbbf1be19d03f9dcd9655"
    sha256 cellar: :any,                 arm64_monterey: "b5e4df60ea8300de0ab06b6c3b59369b8ace64a1da2da40805209b4d1b3dfe87"
    sha256 cellar: :any,                 sonoma:         "06b08542eecffb366c3c92547b4dc74727378346ee05485753e3a2ce5a25b1c4"
    sha256 cellar: :any,                 ventura:        "ca55f014f52d722b07f810b676c8e676982d890fe0c19720c5b0802214fa47f2"
    sha256 cellar: :any,                 monterey:       "888607766d5d61abd954078cb35bfca250a70b9b1af98f7927fe3336569de616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "953cd675e8cbb8359f6dbc6436017dbb58c71ee14ee2764946f833d9a8015225"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "cpp-httplib" => :build
  depends_on "doctest" => :build
  depends_on "pkg-config" => :build
  depends_on "span-lite" => :build
  depends_on "tl-expected" => :build
  depends_on "blake3"
  depends_on "fmt"
  depends_on "hiredis"
  depends_on "xxhash"
  depends_on "zstd"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DENABLE_IPO=TRUE",
                    "-DREDIS_STORAGE_BACKEND=ON",
                    "-DDEPS=LOCAL",
                    *std_cmake_args
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
      gcc-5 gcc-6 gcc-7 gcc-8 gcc-9 gcc-10 gcc-11 gcc-12 gcc-13 gcc-14
      c++ c++3 c++-3.3 c++-4.0
      c++-4.2 c++-4.3 c++-4.4 c++-4.5 c++-4.6 c++-4.7 c++-4.8 c++-4.9
      c++-5 c++-6 c++-7 c++-8 c++-9 c++-10 c++-11 c++-12 c++-13 c++-14
      g++ g++2 g++3 g++-3.3 g++-4.0
      g++-4.2 g++-4.3 g++-4.4 g++-4.5 g++-4.6 g++-4.7 g++-4.8 g++-4.9
      g++-5 g++-6 g++-7 g++-8 g++-9 g++-10 g++-11 g++-12 g++-13 g++-14
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
    system bin/"ccache", "-s"
  end
end
