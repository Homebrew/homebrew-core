class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.10.0.tar.gz"
  sha256 "85803ccbdbdd7a3b03d930187cb055f1353596969c1f92ebec2db839fa4f834a"
  license "BSD-3-Clause"
  revision 1
  head "https://chromium.googlesource.com/webm/libvpx.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "0950fe3a7333c5d00e05f9f4329d73e3441cbcfa75abdd479991a07fca4118a5"
    sha256 cellar: :any,                 big_sur:       "cadad4e7b1bf8d5188da826ac6ecbb7729e0a26ce4665b40fc04386e780c4dc3"
    sha256 cellar: :any,                 catalina:      "766215eed855c02285fca09049dfed646ece4e7b673fd3564fff77befcd8ad27"
    sha256 cellar: :any,                 mojave:        "cd350a6c93f924e991dd36335bad223717037f2cd2a0b6177e973b2b3acae7cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b332cd550581deee0d9c88e5e413f4b7a1ab36a7821920e29861d496391abe2a"
  end

  depends_on "yasm" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-examples
      --disable-unit-tests
      --enable-pic
      --enable-shared
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
