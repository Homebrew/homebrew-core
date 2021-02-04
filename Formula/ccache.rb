class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https://ccache.dev/"
  url "https://github.com/ccache/ccache/releases/download/v4.2/ccache-4.2.tar.xz"
  sha256 "2f14b11888c39778c93814fc6843fc25ad60ff6ba4eeee3dff29a1bad67ba94f"
  license "GPL-3.0-or-later"
  head "https://github.com/ccache/ccache.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "582e21a87c6025f4de138f2a5b47a14a0487f2e6deabf4dd54cfb0d34d27190b"
    sha256 cellar: :any, big_sur:       "4323fd450d0e58cb7c4b76d5254e5a5b44d960d5216073dfeeda41e9baf298f3"
    sha256 cellar: :any, catalina:      "e84ad1c22e01e75f740c910f562935c2d00058aaf4e8bbd09050dfee18f45324"
    sha256 cellar: :any, mojave:        "143ee0131253764d489ba4ff6569ec565c50d50662d878065bdf44d290d23c2b"
  end

  depends_on "cmake" => :build
  depends_on "zstd"

  def install
    # ccache SIMD checks are broken in 4.1, disable manually for now:
    # https://github.com/ccache/ccache/pull/735
    extra_args = []
    if Hardware::CPU.arm?
      extra_args << "-DHAVE_C_SSE2=0"
      extra_args << "-DHAVE_C_SSE41=0"
      extra_args << "-DHAVE_AVX2=0"
      extra_args << "-DHAVE_C_AVX2=0"
      extra_args << "-DHAVE_C_AVX512=0"
    end

    system "cmake", ".", *extra_args, *std_cmake_args
    system "make", "install"

    libexec.mkpath

    %w[
      clang
      clang++
      cc
      gcc gcc2 gcc3 gcc-3.3 gcc-4.0
      gcc-4.2 gcc-4.3 gcc-4.4 gcc-4.5 gcc-4.6 gcc-4.7 gcc-4.8 gcc-4.9
      gcc-5 gcc-6 gcc-7 gcc-8 gcc-9 gcc-10
      c++ c++3 c++-3.3 c++-4.0
      c++-4.2 c++-4.3 c++-4.4 c++-4.5 c++-4.6 c++-4.7 c++-4.8 c++-4.9
      c++-5 c++-6 c++-7 c++-8 c++-9 c++-10
      g++ g++2 g++3 g++-3.3 g++-4.0
      g++-4.2 g++-4.3 g++-4.4 g++-4.5 g++-4.6 g++-4.7 g++-4.8 g++-4.9
      g++-5 g++-6 g++-7 g++-8 g++-9 g++-10
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
