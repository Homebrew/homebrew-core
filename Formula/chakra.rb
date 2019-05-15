class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.9.tar.gz"
  sha256 "b7e9d5b1b6f370e8f7b79dd264c6b9671f79cf8c3c364d481a8fed500163e816"

  bottle do
    cellar :any
    sha256 "eefd6b3651d31ef0d2af22f8f69ae118085d655f651bdde61d12a65ef10f9cf6" => :mojave
    sha256 "f5ea4f06455a23ee1143d7b64631b273d28fae69205534da1f2a18f08c5d5640" => :high_sierra
    sha256 "514c3f1b4dcd5102953f74979998c16d5f815532a2d8a5fb7811e0b023e7551a" => :sierra
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
