class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https://ccache.dev/"
  url "https://github.com/ccache/ccache/releases/download/v4.3/ccache-4.3.tar.xz"
  sha256 "504a0f2184465c306826f035b4bc00bae7500308d6af4abbfb50e33a694989b4"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/ccache/ccache.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "038f86ecd8902ca8714e8d86c1232543d44abf75ee7bb8b3647f8cf2011a7ba3"
    sha256 cellar: :any,                 big_sur:       "083ebd7ddc08f386a9005df99d8c83f6f6b271068ae5b95fc548e4505ab5051b"
    sha256 cellar: :any,                 catalina:      "3a0183557da0fdf94eae62c26ed84e26bd82c31f46198a7efd86ab439521f949"
    sha256 cellar: :any,                 mojave:        "3a5a580f257f28e80bb501f487b2f9f0f8a72114b0039edc0fbe87e1e5e638d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bf3bb826da52e61604f2ab670ecff55b7834306e9b6563b0f1b8d7eacb30e89"
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
