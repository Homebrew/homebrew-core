class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.29.tar.gz"
  sha256 "2ae7e9d3ba189ddcd4231e7255348d3144757d5c2ff8dd853f37e0df783925c0"

  bottle do
    cellar :any
    sha256 "a9d75631f770979df6c63d9bca3537c45cc51db2df877371337395d35f24d802" => :sierra
    sha256 "87bc77e7c58e3651780e455194d80cb8f594a903a5ccb626f4a231eb832a425c" => :el_capitan
    sha256 "f6023e4467d3df12f916c71da84625ec4e4e2ee10c3d52bce52ad82c88e6eba5" => :yosemite
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
