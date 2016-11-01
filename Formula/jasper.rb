class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.16.tar.gz"
  sha256 "349f2261767c51a9e59e37025a027686f45f55cfbb8c46fd55c8697092f9f971"

  bottle do
    cellar :any
    sha256 "dee23dcb033fde04646664169d5d8068a5730cc35a20edee02ed792f0448add5" => :sierra
    sha256 "1e7e07bb1919446f264538f1e51a5f226a5a4a7654488f96864ddc76486c3c56" => :el_capitan
    sha256 "f96f470d1cc6bb74af84e3ff908fbb0a5c5d702b9ed06fc238936e5769f690cd" => :yosemite
  end

  option :universal

  depends_on "jpeg"

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"jasper", "--input", test_fixtures("test.jpg"),
                         "--output", "test.bmp"
    assert_predicate testpath/"test.bmp", :exist?
  end
end
