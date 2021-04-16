class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.10.0.tar.gz"
  sha256 "85803ccbdbdd7a3b03d930187cb055f1353596969c1f92ebec2db839fa4f834a"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libvpx.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5e6492d102cbc698f8b604fcc16f5e07156bacf673be966c0ba13cf364655724"
    sha256 cellar: :any_skip_relocation, big_sur:       "d6c6de387100ba036862042e1d1bfa81faff8dd6668e9b7b35c89dbdc13796f4"
    sha256 cellar: :any_skip_relocation, catalina:      "41c24761694b0bc761d98e6e2c37e711fb0ea30cc39ef6a07e14b9957297c2d5"
    sha256 cellar: :any_skip_relocation, mojave:        "951073a889dd7e072aac6241b70a6b415fef0b8a9f92dc93962eaceb139b3f79"
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
