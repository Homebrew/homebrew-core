class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.8.2.tar.gz"
  sha256 "8735d9fcd1a781ae6917f28f239a8aa358ce4864ba113ea18af4bb2dc8b474ac"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libvpx.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4648d298037c5ac129b41e29a53a39445d7b1d90b90b4eef1eb1d476ae835ab5" => :catalina
    sha256 "d509da7176f5db9dc3953b8380a84386a9e0c9c71ce9d50cd410f84679e00c48" => :mojave
    sha256 "8b2b60c22848752acb6cc470105918932e5f3bf0a45e4af6f3154b1a79ac91c0" => :high_sierra
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
