class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.7.4.tar.gz"
  sha256 "13bf88e4d5618d1706ef2c2456bfbffa56726ae0f3b3640b5a8774bb5c27a83d"
  revision 1

  bottle do
    cellar :any
    sha256 "f088267d3e847b56465b0ffc6df9e743c1152d3ccee8891f087666f00f0be52f" => :high_sierra
    sha256 "fe69ed07fda7c459a39aed8160ff684b390e2697f11735f74d10172192db0e03" => :sierra
    sha256 "5b1e2fb65e9724340e23c90f2013adbf63a3734435a9802375b8a1c81a400f3e" => :el_capitan
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
