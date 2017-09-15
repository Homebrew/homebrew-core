class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.7.2.tar.gz"
  sha256 "83ef95c2b2374e3138bd5b13fc32fb71b6a0be00ce6bd898f6d600345f599e10"

  bottle do
    cellar :any
    sha256 "5373b8ce4b4bae532a7dc6c63cadaa05ba8d73083f1473550c1408552441895a" => :high_sierra
    sha256 "0ddbaa9ad432face1a0a9a8b7afab1369f4bb343524ccba17f8ca1ce842e2f06" => :sierra
    sha256 "67665fa86e0021ef89edb44b2b373a99bd5dd30690b4ec75430e0644cf0ca794" => :el_capitan
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
