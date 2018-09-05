class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://savannah.nongnu.org/download/openexr/openexr-2.2.0.tar.gz"
  sha256 "36a012f6c43213f840ce29a8b182700f6cf6b214bea0d5735594136b44914231"
  revision 1

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

  # Fixes builds on 32-bit targets due to incorrect long literals
  # Patches are already applied in the upstream git repo.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f1a3ea4f69b7a54d8123e2f16488864d52202de8/openexr/64bit_types.patch"
    sha256 "c95374d8fdcc41ddc2f7c5b3c6f295a56dd5a6249bc26d0829548e70f5bd2dc9"
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
