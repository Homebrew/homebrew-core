class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.6.0.tar.gz"
  sha256 "c98d7d52f02a3da2190c86d573498f41eb71ff6c3570e0444dec4e0537b1f1de"

  bottle do
    cellar :any
    sha256 "bf5bc62001e254644c5426f74de7cfae036286330fe965ac0beb8831e292e2b3" => :sierra
    sha256 "d4642feaed260c5891354f4b46ed232fa49b781e49acb8029b25ec590537afb6" => :el_capitan
    sha256 "98b59b6e4e7cb052880b3bcdfada6c6b8b66523e7d01a46d09fcfbc8eaa0742f" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "icu4c"

  def install
    system "./build.sh", "--lto-thin", "--static", "--icu=#{Formula["icu4c"].opt_include}", "-j=#{ENV.make_jobs}", "-y"
    bin.install "out/Release/ch" => "chakra"
  end

  test do
    (testpath/"test.js").write("print('Hello world!');\n")
    assert_equal "Hello world!", shell_output("#{bin}/chakra test.js").chomp
  end
end
