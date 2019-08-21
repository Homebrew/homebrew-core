class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.8.1.tar.gz"
  sha256 "df19b8f24758e90640e1ab228ab4a4676ec3df19d23e4593375e6f3847dee03e"
  head "https://chromium.googlesource.com/webm/libvpx", :using => :git

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0e1d5f53082f7718604f11a6df4ff9edd219892cd5eef4c4a7c5875dcf9876f2" => :mojave
    sha256 "b67db059b122aa25a17fff630cc04cba531a95b33b6032ac5ba78434325f0700" => :high_sierra
    sha256 "12c14d42a563fc9d2b94f6733b45816fb21e70f4fd3229c9398e115af49f9bc0" => :sierra
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
