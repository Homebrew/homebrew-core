class Ccache < Formula
  desc "Object-file caching compiler wrapper"
  homepage "https://ccache.dev/"
  url "https://github.com/ccache/ccache/releases/download/v4.1/ccache-4.1.tar.xz"
  sha256 "5fdc804056632d722a1182e15386696f0ea6c59cb4ab4d65a54f0b269ae86f99"
  license "GPL-3.0-or-later"
  head "https://github.com/ccache/ccache.git"

  bottle do
    cellar :any
    sha256 "ba8c28a2cc2a76753263e785ea4055bb0859cf1b966015755fb025335d7c21fa" => :big_sur
    sha256 "1fcd4dbb4b915a0938911157556dd8bfa43303987d752236618002ec7d809818" => :arm64_big_sur
    sha256 "234a4d2ba07206b539a347adff99f283da2bf219775e30da5567140cbd7c4fdf" => :catalina
    sha256 "bd87ccc67069931f9a4b1833c6ac97f9168425fc4b5680d152f18b64cd87e825" => :mojave
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
