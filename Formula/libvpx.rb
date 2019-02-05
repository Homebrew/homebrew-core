class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.8.0.tar.gz"
  sha256 "86df18c694e1c06cc8f83d2d816e9270747a0ce6abe316e93a4f4095689373f6"
  head "https://chromium.googlesource.com/webm/libvpx", :using => :git

  bottle do
    rebuild 1
    sha256 "ea63d0340f8acb7222773e1c702caa60aa843cb7106a44880b9e49b258cc0724" => :mojave
    sha256 "c908bf9b9438bee689162350cdf89e6a7ac612b556dfe557dd6cfee89ff043a8" => :high_sierra
    sha256 "793fbaf38b905d1831c1264e37bd874e20d563cc4e93878b42ff42471db4679a" => :sierra
  end

  depends_on "yasm" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-examples
      --disable-unit-tests
      --enable-pic
    ]

    # https://bugs.chromium.org/p/webm/issues/detail?id=1475
    args << "--disable-avx512" if MacOS.version <= :el_capitan

    mkdir "macbuild" do
      system "../configure", *args
      system "make", "install"
    end
  end

  test do
    system "ar", "-x", "#{lib}/libvpx.a"
  end
end
