class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https://ccache.dev/"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/ccache/ccache.git", branch: "master"

  stable do
    url "https://github.com/ccache/ccache/releases/download/v4.4/ccache-4.4.tar.xz"
    sha256 "b40bea2ecf88fc15d4431f0d5fb8babf018d7218eaded0f40e07d4c18c667561"
    # make testsuite runner cope with symlinked /tmp
    # see: https://github.com/ccache/ccache/issues/916 (will be part of a post 4.4 release)
    patch do
      url "https://github.com/ccache/ccache/commit/2397a0605a24d61d60738fa21591510a9fa24eed.patch?full_index=1"
      sha256 "1222a77fc312a2b9e8b62603a45903da2388b59baa9c8a9005fa54f16342b838"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "c7da75f26f701903246a5c842dcaf2d4832ad333f445a001df09e0746c233733"
    sha256 cellar: :any,                 big_sur:       "01a6eb140be4b65cd4309e5248dea5cb715ffb790bada58a0b1bbca569660543"
    sha256 cellar: :any,                 catalina:      "d9f4da69ace3c9ace3ce16caed6f5eef19b8adb7e83acfa6eed80282384c2cfa"
    sha256 cellar: :any,                 mojave:        "3d73453a7262b646f5dabd071b3a70bf1520f28452dc87b8d786f8c22039a235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3f06b7820de6995da85d7c05d0678ab1dff05ff06c71300192c1167c45a3f5b"
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
    system "cmake", ".", *std_cmake_args, "-DENABLE_IPO=TRUE"
    system "make"
    # ccache test suite fails with the homebrew compiler shim
    system "cmake", "-E", "env", "CC=/usr/bin/#{DevelopmentTools.default_compiler}", "ctest", "-j#{ENV.make_jobs}"
    system "make", "install"

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
