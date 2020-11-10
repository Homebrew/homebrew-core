class Chakra < Formula
  desc "Core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/microsoft/ChakraCore/archive/v1.11.23.tar.gz"
  sha256 "b5ee89079e2f943a8df9ec1b3bd49432b030881bbae833ad6f2e34cefab53401"
  license "MIT"

  bottle do
    cellar :any
    sha256 "3ef73dc70184cab11c3f9d90dfa03c72f57997df92394eac2b2154379e7e2896" => :catalina
    sha256 "fddabb1e3ea5ea28b715284b06e7c441c1e80f131d725e1cdf138ef83e5b4225" => :mojave
    sha256 "526280b701cb815ac523ed9dc95b69af4a4d9402ad35483583ca1c5ce7b8b62b" => :high_sierra
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
