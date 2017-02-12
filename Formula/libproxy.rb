class Libproxy < Formula
  desc "Library that provides automatic proxy configuration management"
  homepage "https://libproxy.github.io/libproxy/"
  url "https://github.com/libproxy/libproxy/archive/0.4.14.tar.gz"
  sha256 "6220a6cab837a8996116a0568324cadfd09a07ec16b930d2a330e16d5c2e1eb6"
  head "https://github.com/libproxy/libproxy.git"

  bottle do
    sha256 "3efe53e47f393d978c1cba75c56ed8a550848182e5b80e92abb23cf3af12c79d" => :sierra
    sha256 "d1aa41e48f2380cca100bfce1fda8c98645e14e0d63c34ea3750d3d5be1d4e92" => :el_capitan
    sha256 "0acc5be47d4c208d48d0b21fd676953feda403b119990f7388837d0cd36fbf24" => :yosemite
  end

  depends_on "cmake" => :build
  # Non-fatally fails to build against system Perl, so stick to Homebrew's here.
  depends_on "perl" => :optional
  depends_on :python if MacOS.version <= :snow_leopard

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
