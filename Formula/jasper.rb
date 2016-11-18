class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.29.tar.gz"
  sha256 "2ae7e9d3ba189ddcd4231e7255348d3144757d5c2ff8dd853f37e0df783925c0"

  bottle do
    cellar :any
    sha256 "ef1142ea83ad6a5ce3a92d64e80685c1447a87d2062bde5d456b626fb620e5d3" => :sierra
    sha256 "d262d3b14633bff763b58871de361eacf9354d8017a76430cfb957da1fed32a4" => :el_capitan
    sha256 "bc8e00968ac570ddecb7a78796ae245e29ef9326d8ace577ce29ba96b12f87c4" => :yosemite
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
