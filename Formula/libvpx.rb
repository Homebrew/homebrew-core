class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.9.0.tar.gz"
  sha256 "d279c10e4b9316bf11a570ba16c3d55791e1ad6faa4404c67422eb631782c80a"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libvpx.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9fb33bbcc029287ea3b368a3242d7ae215951a63e3809c71268380f2a41a763b" => :big_sur
    sha256 "3d10e091280b6f1f9c9f527b5caed4715f6a2163942f9af058ed553b3585a855" => :arm64_big_sur
    sha256 "19a684e5b0a2109b40a6c412517ad8639200c76d8bd527e98fc24d9589bb1c4e" => :catalina
    sha256 "c813698920d7e5144ae45f9922477cc30ed4f7ee81463977b01d50af43e0be19" => :mojave
    sha256 "13e231eb9c8158e84df24a58c8b96f3f57e9202ad680b4be3bbaf7e67f40aaac" => :high_sierra
  end

  depends_on "yasm" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-examples
      --disable-unit-tests
      --enable-pic
      --enable-vp9-highbitdepth
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
