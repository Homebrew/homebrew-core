class Jasper < Formula
  desc "Library for manipulating JPEG-2000 images"
  homepage "https://www.ece.uvic.ca/~frodo/jasper/"
  url "https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.16.tar.gz"
  sha256 "349f2261767c51a9e59e37025a027686f45f55cfbb8c46fd55c8697092f9f971"

  bottle do
    cellar :any
    rebuild 1
    sha256 "651d5848165b40c6ad8fc7474a7f7767ad228a56481d647eb148f626200566ad" => :sierra
    sha256 "c70ac7c5c48f01d60d8ef07f8d951cc6ffc4da507bc2218950fed542a2fd5902" => :el_capitan
    sha256 "7a996d9e2a97fd46aceda93413c3e55a4e46be3afae16f4631743cb6ce2602d6" => :yosemite
    sha256 "f3deabb9253d2a32eeb5f4848613e7f18bd3af5e5e44b0c467059f5477b60e31" => :mavericks
    sha256 "b6c2560da91773d9b39a9b77064edeb0a19bf32ada3ae057b38c28025a900975" => :mountain_lion
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
