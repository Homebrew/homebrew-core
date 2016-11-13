class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.28.tar.gz"
  sha256 "e94691dc026c8c9ac26db0fc303562e93a141a4b1c9aa9a16a40b9eb345d515b"

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
