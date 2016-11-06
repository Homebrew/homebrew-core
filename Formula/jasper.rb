class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"

  stable do
    url "https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.21.tar.gz"
    sha256 "e9c8a241f80d1cc190c308f5efc6669a98776ed27458643553abee823fadd7b3"

    # Remove for > 1.900.21
    # Fixes test failure "jpg_mkimage failed; error: cannot load image data"
    # Upstream commit "Fixed a bug in the JPEG codec caused by an integral
    # promotion problem."
    patch do
      url "https://github.com/mdadams/jasper/commit/fa6834f.patch"
      sha256 "80ca3aaafea9986a90201d36a13b00dc9effdb6c1363c02382c9193b49dd0e7b"
    end
  end

  bottle do
    cellar :any
    sha256 "dee23dcb033fde04646664169d5d8068a5730cc35a20edee02ed792f0448add5" => :sierra
    sha256 "1e7e07bb1919446f264538f1e51a5f226a5a4a7654488f96864ddc76486c3c56" => :el_capitan
    sha256 "f96f470d1cc6bb74af84e3ff908fbb0a5c5d702b9ed06fc238936e5769f690cd" => :yosemite
  end

  head do
    url "https://github.com/mdadams/jasper.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "jpeg"

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    ENV.universal_binary if build.universal?
    system "autoreconf", "-fiv" if build.head?
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
