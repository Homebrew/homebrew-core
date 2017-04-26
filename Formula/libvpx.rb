class Libvpx < Formula
  desc "VP8 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.6.1.tar.gz"
  sha256 "cda8bb6f0e4848c018177d3a576fa83ed96d762554d7010fe4cfb9d70c22e588"
  head "https://chromium.googlesource.com/webm/libvpx", :using => :git

  bottle do
    sha256 "fe46c1d9fc5e1ea1176791f9e4a85d896eb311d094be77c7c44c2b24facc4300" => :sierra
    sha256 "100634d26cac4b4e69f1a5eea21b98ae577e3a1364169fe483bc4cc9c29f6047" => :el_capitan
    sha256 "68b90c8901f765d0a50ea89a030b40f53e0fc7c2e4bb554859f6ae9fc2a2c4f2" => :yosemite
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
