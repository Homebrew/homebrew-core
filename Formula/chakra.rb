class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.7.6.tar.gz"
  sha256 "545b60fd2ab2aae537c3582a13c40d105663b9a23de49ebcfdfa98e042fee87f"

  bottle do
    cellar :any
    sha256 "3f87275a979f633727ff635e781c3a2f07c5f63d5bec39e6b22adaa4b4cbaaac" => :high_sierra
    sha256 "2c60ac56c323706903313613aae1bae5f40cbafe5c1ef41f98aafcdad500fa8e" => :sierra
    sha256 "d8eb625f0b078345ef7deaad305f1fb177d39e4678e5b0aa1c32cad425279242" => :el_capitan
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
