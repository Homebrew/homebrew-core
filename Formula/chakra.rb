class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.7.tar.gz"
  sha256 "3655a73dea56ed8aa11428f0564408fd7140140ed1de49bafcfec220253252d9"
  revision 1

  bottle do
    cellar :any
    sha256 "35f1254b31fb83ae9a0a3b0a4b65f31202df3d1a3c930f8ef492b655978a458a" => :mojave
    sha256 "d08439664c47cbf3df27ab3a6f0d1f11b9eee11b88a8551c88408d62f7c452be" => :high_sierra
    sha256 "1fb6274f2d470bbb085347957cf25bf18ed696ce8c38f1754276fc573220772d" => :sierra
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
