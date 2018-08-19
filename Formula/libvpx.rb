class Libvpx < Formula
  desc "VP8/VP9 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.7.0.tar.gz"
  sha256 "1fec931eb5c94279ad219a5b6e0202358e94a93a90cfb1603578c326abfc1238"
  head "https://chromium.googlesource.com/webm/libvpx", :using => :git

  bottle do
    sha256 "582a9263b17830dd1ed640bd21e1779843071e8e638a53774bb32a19ef7b7839" => :mojave
    sha256 "5df5088250c3061e8e6d508525b46959ee3cb46504097b95342bf06a1f2d92ef" => :high_sierra
    sha256 "75b004234a3bd81686d4ddd985bc87327a6f32937a484d12209aa23e85a74292" => :sierra
    sha256 "853cfd3f79bfa0c8006ea37644a8ccf1674a2e24abf03521c12457ee99d8242d" => :el_capitan
  end

  option "with-gcov", "Enable code coverage"
  option "with-visualizer", "Enable post processing visualizer"
  option "with-examples", "Build examples (vpxdec/vpxenc)"
  option "with-highbitdepth", "Enable high bit depth support for VP9"

  deprecated_option "gcov" => "with-gcov"
  deprecated_option "visualizer" => "with-visualizer"

  depends_on "yasm" => :build

  # configure misdetects 32-bit 10.6
  # https://code.google.com/p/webm/issues/detail?id=401
  depends_on :macos => :lion

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-pic
      --disable-unit-tests
    ]

    # https://bugs.chromium.org/p/webm/issues/detail?id=1475
    args << "--disable-avx512" if MacOS.version <= :el_capitan

    args << (build.with?("examples") ? "--enable-examples" : "--disable-examples")
    args << "--enable-gcov" if !ENV.compiler == :clang && build.with?("gcov")
    args << "--enable-postproc" << "--enable-postproc-visualizer" if build.with? "visualizer"
    args << "--enable-vp9-highbitdepth" if build.with? "highbitdepth"

    mkdir "macbuild" do
      system "../configure", *args
      system "make", "install"
    end
  end

  test do
    system "ar", "-x", "#{lib}/libvpx.a"
  end
end
