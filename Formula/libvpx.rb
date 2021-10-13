class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.11.0.tar.gz"
  sha256 "965e51c91ad9851e2337aebcc0f517440c637c506f3a03948062e3d5ea129a83"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libvpx.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "2edfb6a133be8947da27719975dbd19dd6233e12f21d221bea7f6008cfbc51a2"
    sha256 cellar: :any,                 big_sur:       "73d6365843bd6b8c868b3bf020152225d06304117c23c2a1e579ce347d3ab4e1"
    sha256 cellar: :any,                 catalina:      "28194ea0a917dcfecbfdcd51cb37da4ae1697238e3c2dedc769c502b435124c7"
    sha256 cellar: :any,                 mojave:        "378b9f6680ea8a99c064d8acd0cfbfbf2a1c142d8c4f27cf935dcfed3342cc61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e79ec2f50112da2b5adfc83b46604af182af8364410c9ec686c6c519c133229d"
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

    if Hardware::CPU.intel?
      ENV.runtime_cpu_detection
      args << "--enable-runtime-cpu-detect"
    end

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
