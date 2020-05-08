class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/openexr/openexr/archive/v2.5.1.tar.gz"
  sha256 "11f806bf256453e39fc33bd1cf1fa576a54f144cedcdd3e6935a177e5a89d02e"

  bottle do
    sha256 "436a68a4101b82d9abe8f21045efa6d5912a4a6bb070614cc04a88487a0b8372" => :catalina
    sha256 "d9cfcbd95203891e434ed18ffba6cc7e3ccf30295258b9335fa75ab385e74311" => :mojave
    sha256 "834e89287ea987db4d6e392dd523c3ef193a991f44e015d54f7b40e1f49b48d0" => :high_sierra
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
