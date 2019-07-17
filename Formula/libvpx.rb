class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.8.1.tar.gz"
  sha256 "df19b8f24758e90640e1ab228ab4a4676ec3df19d23e4593375e6f3847dee03e"
  head "https://chromium.googlesource.com/webm/libvpx", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "b171a1cd0acd98ef77d5ecb1ff2949ded7b8e513cc076ab42cfbe9bf26f3d5be" => :mojave
    sha256 "519728a547408f2b0414d09555794310198d5eaf7f2eb7571995eedd18fae1f4" => :high_sierra
    sha256 "23e177ec26593170c6a9e2d3e2f665e56124d8495cf36f822b5860e5bce3691f" => :sierra
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
