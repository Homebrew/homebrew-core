class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/openexr/openexr/archive/v2.5.2.tar.gz"
  sha256 "5da8dff448d0c4a529e52c97daf238a461d01cd233944f75095668d6d7528761"

  bottle do
    sha256 "47c325cb83311e1e25666d3863623682a077a8ee80ad10f1d659c1095650b5c4" => :catalina
    sha256 "3ba3fbee2b8156d313b137701a8f43a971ecd11bd63c891348d061b03858358e" => :mojave
    sha256 "17dd7782b40a65432313638b9250afbb8cb0946bf442e8d46603f98c97fc0f2b" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ilmbase"

  uses_from_macos "zlib"

  resource "exr" do
    url "https://github.com/openexr/openexr-images/raw/master/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    cd "OpenEXR" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
