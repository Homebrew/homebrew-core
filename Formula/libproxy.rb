class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/0.4.15.tar.gz"
  sha256 "18f58b0a0043b6881774187427ead158d310127fc46a1c668ad6d207fb28b4e0"
  head "https://github.com/libproxy/libproxy.git"

  bottle do
    sha256 "e2ca77c5398273eb7fd3645eed6f2f393bb78d3cb8f1cbbe66530be6fdc2d92d" => :high_sierra
    sha256 "2da6c1c16c4d821a03f3af0095e8c083650d8236b2a9a08cb5af1b2b235658a7" => :sierra
    sha256 "2afb8712e1a562617d7ab8fcd1436290e83f65dd636e1927761d2e9e914879cc" => :el_capitan
    sha256 "af63072e26e2dd635ff04988d1dbb68e4f83d966aad935a6071072fe22508f15" => :yosemite
  end

  depends_on "cmake" => :build
  # Non-fatally fails to build against system Perl, so stick to Homebrew's here.
  depends_on "perl" => :optional
  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    args = std_cmake_args + %W[
      ..
      -DPYTHON2_SITEPKG_DIR=#{lib}/python2.7/site-packages
      -DWITH_PYTHON3=OFF
    ]

    if build.with? "perl"
      args << "-DPX_PERL_ARCH=#{lib}/perl5/site_perl"
      args << "-DPERL_LINK_LIBPERL=YES"
    else
      args << "-DWITH_PERL=OFF"
    end

    mkdir "build" do
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    assert_equal "direct://", pipe_output("#{bin}/proxy 127.0.0.1").chomp
  end
end
