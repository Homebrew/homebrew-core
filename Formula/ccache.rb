class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https://ccache.dev/"
  url "https://github.com/ccache/ccache/releases/download/v4.4.2/ccache-4.4.2.tar.xz"
  sha256 "9200cafbaa5fd62c2600fccb40a18214e57747825e6cdcd76688b4b61c2dcba0"
  license "GPL-3.0-or-later"
  head "https://github.com/ccache/ccache.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "8bd6f0c7a2be356d80dc3f3b7f4fc19c8f484d2ef54d2b32962e2a1424c9baf9"
    sha256 cellar: :any,                 big_sur:       "afde6d985a061172f8198afd9de6e9e2554ae8cbbc3ba6ec73623828f28573f7"
    sha256 cellar: :any,                 catalina:      "a74ce23938bbc688095a61c02e7b9c16909892cb77e8076ed927621aac7ff40a"
    sha256 cellar: :any,                 mojave:        "277d9a16e70579c2a973ad0a1d9c582e94f07e9a3f70574a8489f1dd98c0a43b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3e36011842a11c2ba1c38a3d769cb9a206b45333e50c33c555be3e007df617d"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "hiredis"
  depends_on "zstd"

  on_linux do
    depends_on "gcc"
  end

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
      gcc-5 gcc-6 gcc-7 gcc-8 gcc-9 gcc-10 gcc-11
      c++ c++3 c++-3.3 c++-4.0
      c++-4.2 c++-4.3 c++-4.4 c++-4.5 c++-4.6 c++-4.7 c++-4.8 c++-4.9
      c++-5 c++-6 c++-7 c++-8 c++-9 c++-10 c++-11
      g++ g++2 g++3 g++-3.3 g++-4.0
      g++-4.2 g++-4.3 g++-4.4 g++-4.5 g++-4.6 g++-4.7 g++-4.8 g++-4.9
      g++-5 g++-6 g++-7 g++-8 g++-9 g++-10 g++-11
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
