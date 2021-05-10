class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https://ccache.dev/"
  url "https://github.com/ccache/ccache/releases/download/v4.3/ccache-4.3.tar.xz"
  sha256 "504a0f2184465c306826f035b4bc00bae7500308d6af4abbfb50e33a694989b4"
  license "GPL-3.0-or-later"
  head "https://github.com/ccache/ccache.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "035a9c51376fbd87424fd98b75e304ca361b3bd0dc92bdcae7b1e5dcfa22a3c0"
    sha256 cellar: :any, big_sur:       "098a882c947780055053e5d961910f411026cea492a0435077b3c70a347b4ca7"
    sha256 cellar: :any, catalina:      "fdcfcc5d633cbae1334d7862f92e00cfaca04bc1722299b37acd61647779325b"
    sha256 cellar: :any, mojave:        "ffc07ff2a5079f66f770534bf9d0db2cbd330e8a6bd560f2e4509866be09aad9"
  end

  depends_on "cmake" => :build
  depends_on "zstd"

  def install
    system "cmake", ".", *std_cmake_args
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
