class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.7.tar.gz"
  sha256 "3655a73dea56ed8aa11428f0564408fd7140140ed1de49bafcfec220253252d9"
  revision 1

  bottle do
    cellar :any
    sha256 "63b122da03feb9cb02feeb95b6d84c75df06f4a3095e9a359afca6e46d9ea311" => :mojave
    sha256 "1027235beb492b5f9e370f68396bc0e11df4159cebcd70a230cce5f5684b7399" => :high_sierra
    sha256 "a626827f2e56e07ecb2820d9c4eab4c90c0e5d01166b3adc68ba259e037dc8fb" => :sierra
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
