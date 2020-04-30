class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.19.tar.gz"
  sha256 "db21584c5b557af622e6fc45e97e80ae579a0e33805ffb123dea2ddaf36b4dae"
  revision 1

  bottle do
    cellar :any
    sha256 "ee5d817b5f09de2c9732e170d56a16401567291a30494c1b88538a07ac6a2dcd" => :catalina
    sha256 "f2d4717a68caf15784f57a5257d0f53ec0e96f62cec2c79719f1584aa6447aea" => :mojave
    sha256 "2c2b30dbfa3d7260acceb052b0d4d41492dc3fa384ac289c749b8ac296d5b1cf" => :high_sierra
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
