class Chakra < Formula
  desc "Core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.24.tar.gz"
  sha256 "b99e85f2d0fa24f2b6ccf9a6d2723f3eecfe986a9d2c4d34fa1fd0d015d0595e"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, big_sur:  "f57518d03ba2daf07758454a0cbe902a62f86f70a47f60b6b3b7248586ca48a8"
    sha256 cellar: :any, catalina: "7a58925fe9d66f440d2c50e453d013b3a535e33070bc5053c752f59c1786f1be"
    sha256 cellar: :any, mojave:   "16d11693872d1222374124d8d7db4032dc2af035260231837af86b87685723bb"
  end

  depends_on "cmake" => :build
  depends_on "icu4c"

  def install
    args = [
      "--lto-thin",
      "--icu=#{Formula["icu4c"].opt_include}",
      "--extra-defines=U_USING_ICU_NAMESPACE=1", # icu4c 61.1 compatibility
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
