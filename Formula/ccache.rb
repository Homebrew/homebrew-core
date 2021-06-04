class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https://ccache.dev/"
  url "https://github.com/ccache/ccache/releases/download/v4.3/ccache-4.3.tar.xz"
  sha256 "504a0f2184465c306826f035b4bc00bae7500308d6af4abbfb50e33a694989b4"
  license "GPL-3.0-or-later"
  head "https://github.com/ccache/ccache.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "77ef6571b788e52f9f90d95911955ce9cfedf8a971c7634a3d5ae9014ae7777c"
    sha256 cellar: :any, big_sur:       "017d4408111c3f5146c95a18aaa11d9dc623af7d257386f28b80076a98798bcd"
    sha256 cellar: :any, catalina:      "4e905bb6bba1479b2cdf3c93c10f21684f50ac7dbdbada7d292aaaa58e87f7a2"
    sha256 cellar: :any, mojave:        "8001d6a3ff290c51eccc358c465d652758243540a9647606b608d6b6312b34e3"
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
