class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.22.tar.gz"
  sha256 "ed08776728c30dd9bf8873838ddbfef77e9db66a584d3a3dd1f668bff2b3eda8"
  license "MIT"

  bottle do
    cellar :any
    sha256 "f0a9ca478b67d0c8d73d2cbe8a071fdc09ad069dbea154e2b13308eb26fcb283" => :catalina
    sha256 "03a49b0bb12238a4ed03953c87a1cf419cfde07b315a2052b2a7e368aec8bb19" => :mojave
    sha256 "12c8224078b68833e3eb1556c4c69d32b2c38c06e91fa485e0d260e2947bc983" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "icu4c"

  def install
    args = [
      "--lto-thin",
      "--icu=#{Formula["icu4c"].opt_include}",
      "--extra-defines=U_USING_ICU_NAMESPACE=1", # icu4c 61.1 compatability
      "-j=#{ENV.make_jobs}",
      "-y",
    ]

    # Build dynamically for the shared library
    system "./build.sh", *args
    # Then statically to get a usable binary
    system "./build.sh", "--static", *args

    bin.install "out/Release/ch" => "chakra"
    include.install Dir["out/Release/include/*"]
    lib.install "out/Release/libChakraCore.dylib"
  end

  test do
    (testpath/"test.js").write("print('Hello world!');\n")
    assert_equal "Hello world!", shell_output("#{bin}/chakra test.js").chomp
  end
end
