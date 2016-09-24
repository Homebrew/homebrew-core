class Libvpx < Formula
  desc "VP8 video codec"
  homepage "https://www.webmproject.org/code/"
  url "https://github.com/webmproject/libvpx/archive/v1.6.0.tar.gz"
  sha256 "e2fc00c9f60c76f91a1cde16a2356e33a45b76a5a5a1370df65fd57052a4994a"
  head "https://chromium.googlesource.com/webm/libvpx", :using => :git

  bottle do
    sha256 "47a0e17e27fb345630f5bad78aeb7bf88699a96f8d78a62c84c0be7e9e165cc7" => :sierra
    sha256 "4027dc0598de4c1d78bb1a917f90a892dcb41fa0806db41b57205d3e20d2424c" => :el_capitan
    sha256 "3e13f428741842f512cb0cad523fd5816c7b4badae49d1af5a2698ef24077ef7" => :yosemite
    sha256 "44e4a3450e6af4894c51924fd01c04efceb3d9c42bc4064d414c5d4979c24eef" => :mavericks
  end

  option "with-gcov", "Enable code coverage"
  option "with-visualizer", "Enable post processing visualizer"
  option "with-examples", "Build examples (vpxdec/vpxenc)"

  deprecated_option "gcov" => "with-gcov"
  deprecated_option "visualizer" => "with-visualizer"

  depends_on "yasm" => :build

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

    # configure misdetects 32-bit 10.6
    # https://code.google.com/p/webm/issues/detail?id=401
    if MacOS.version == "10.6" && Hardware::CPU.is_32_bit?
      args << "--target=x86-darwin10-gcc"
    end

    mkdir "macbuild" do
      system "../configure", *args
      system "make", "install"
    end
  end
end
