class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.8.1.tar.gz"
  sha256 "df19b8f24758e90640e1ab228ab4a4676ec3df19d23e4593375e6f3847dee03e"
  head "https://chromium.googlesource.com/webm/libvpx", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "8acc007976c337e0ea107c07e984c7924516b1ce70fe7a862af480de0998cb96" => :mojave
    sha256 "4afe71bb1bf3e449e9ed854f04fbed14338be71a2f60122c09f37da8faa9d1ef" => :high_sierra
    sha256 "bc0817cc35d2437b579572842bcfdfb846a26a241986b801b86d5ec52bf2cf51" => :sierra
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
