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
    sha256 "c520675bcea396ecfe50ba9f3c61223074f60679402052d0ff91cdb63ea6fc90" => :sierra
    sha256 "a80f5f11bc8d51696b061efec07d67e6b51b11230682ed56de2fd6c0c4e5247f" => :el_capitan
    sha256 "0bc94eb7de6db6cb130a725c84fa14ef25f4a354eb10182e8c48142b4e7111b2" => :yosemite
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
