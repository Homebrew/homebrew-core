class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https://ccache.dev/"
  url "https://github.com/ccache/ccache/releases/download/v4.0/ccache-4.0.tar.xz"
  sha256 "ac1b82fe0a5e39905945c4d68fcb24bd0f32344869faf647a1b8d31e544dcb88"
  license "GPL-3.0-or-later"
  head "https://github.com/ccache/ccache.git"

  bottle do
    cellar :any
    sha256 "bc3f6023af2d28b814d9f3cfe3da0c5750f73989d81e6d9288eda64652ae57d7" => :catalina
    sha256 "f2bf635b762f66ff74909679b80fff0c0e8bc6e4a10d6745a9dc0529ac3bf200" => :mojave
    sha256 "dab9f687dc351118a4b69d4d7f8bb87eb39cbf44acb42c66f2c9286b3e050877" => :high_sierra
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
