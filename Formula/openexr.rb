class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/openexr/openexr/releases/download/v2.3.0/openexr-2.3.0.tar.gz"
  sha256 "fd6cb3a87f8c1a233be17b94c74799e6241d50fc5efd4df75c7a4b9cf4e25ea6"

  bottle do
    cellar :any
    sha256 "a00afa239c0fc0a7cf87689afb2522b7cc8887644a0626d9a7911b2eb4a0e8f5" => :mojave
    sha256 "6c96d4cae23adcf59f5a656ae922e919bf38b55cb69c1d66a7bb50d120a38a25" => :high_sierra
    sha256 "d05f50377503a0b3a367e69ce463941487128c970cfb8f4db32cfb14c23a34f6" => :sierra
    sha256 "f8d152a55c42645a8871906ff4d5d3f39fb8885cd02b6648ffabb3eef93e5beb" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "ilmbase"

  resource "exr" do
    url "https://github.com/openexr/openexr-images/raw/master/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    resource("exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
