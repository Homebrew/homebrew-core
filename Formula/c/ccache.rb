class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https://ccache.dev/"
  license "GPL-3.0-or-later"
  head "https://github.com/ccache/ccache.git", branch: "master"

  stable do
    # TODO: Remove `stable` block at next release (after removing patches below)
    url "https://github.com/ccache/ccache/releases/download/v4.10/ccache-4.10.tar.xz"
    sha256 "83630b5e922b998ab2538823e0cad962c0f956fad1fcf443dd5288269a069660"

    # Fix detection of system blake3
    # https://github.com/ccache/ccache/pull/1464
    patch do
      url "https://github.com/ccache/ccache/commit/d159306db8398da233df6481ac3fd83460ef0f0b.patch?full_index=1"
      sha256 "1db1a39677b94cd365b98d8df1fcd0b116866175d4a55730af9bfa1ab443e4be"
    end

    # Fix blake3 include. Same PR as above.
    patch do
      url "https://github.com/ccache/ccache/commit/fa4046966e71011587364b0241255130b62858fb.patch?full_index=1"
      sha256 "c0d5d61e3ef594c0587e249798e95c9d508f41452fd649685b8f6a00e667be80"
    end
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "4e72285f6d94410d3baf40dc04052bb546dc5ab7d7bc01d7ac7ca70e64b24020"
    sha256 cellar: :any,                 arm64_ventura:  "8043e413c18d0c598653b309275cd8c3fb974d4020f95b1ea85941f0ce9262c4"
    sha256 cellar: :any,                 arm64_monterey: "5ca62fe4461f482f453a589e9bb80c8fdd2c3eadd94fc0bef52b104fc25d13d0"
    sha256 cellar: :any,                 sonoma:         "6df01b817d2bfed4194adc1aecb269403dac1c628db61e092137afbbaf97b359"
    sha256 cellar: :any,                 ventura:        "cfba61f8bc211cdd291d71ebce4756779df320f42c0dc5dd5b22388d10f95dbc"
    sha256 cellar: :any,                 monterey:       "76ca517d84c07890373dd7ecc00524de556cde1eaf7f56da1575b8a2b88e1297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d82ff8a8f096ef8506b29def639240dff809d12728e6be088698022f93bbbda"
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
    system "#{bin}/ccache", "-s"
  end
end
