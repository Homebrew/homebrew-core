class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://savannah.nongnu.org/download/openexr/openexr-2.2.0.tar.gz"
  sha256 "36a012f6c43213f840ce29a8b182700f6cf6b214bea0d5735594136b44914231"

  bottle do
    cellar :any
    rebuild 1
    sha256 "12c2585a07369da6668cacffe07ddd7a6b0f9750d107f0d053eefcb992e4df85" => :high_sierra
    sha256 "0220d0edcb161cb56a1cbe8477cc2ecd45fee320ce48f99c114454421a527198" => :sierra
    sha256 "a73d66076b03d20908db659b965cee768d82408ddca5196fef8164b779091765" => :el_capitan
    sha256 "ad973fc780bb731a5ee8be347283903e8343448913e46a23fbdede0145ef980a" => :yosemite
    sha256 "9c21b70caff58d8d699a58a50249f220b03c23f450a219276782827e6c03ff33" => :mavericks
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
