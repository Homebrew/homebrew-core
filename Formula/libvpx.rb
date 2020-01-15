class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.8.2.tar.gz"
  sha256 "8735d9fcd1a781ae6917f28f239a8aa358ce4864ba113ea18af4bb2dc8b474ac"
  head "https://chromium.googlesource.com/webm/libvpx", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "7e25f992f2da9c062dae318891f87bbe8fb25b92d6ad96d55b471714a26f54f5" => :catalina
    sha256 "7441bce9e2934582467b4d1f5c7a5669f0f2867f89d9766a987d0145d3354e29" => :mojave
    sha256 "a92327055c847f4444248a9d47650d999baffd27d7e073a42b7a67c0fccd6c33" => :high_sierra
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
