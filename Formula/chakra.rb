class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/microsoft/ChakraCore/archive/v1.11.20.tar.gz"
  sha256 "2d7b70db1ab01cd8c3e519639f560b7787abafe4bc41dfb862095a3573f76f0d"
  license "MIT"

  bottle do
    cellar :any
    sha256 "7ba3b69a2708111e59c5c4523fe6cc86607a6dabf182980d3507d8ae5bfa73e7" => :catalina
    sha256 "06e7b9379e81f2151abb8db1858ce3ee29fb22a8971f7ae7224f48889d50cba9" => :mojave
    sha256 "3dac54461da29e9849fcc60f25e8a55be79f336d0649d382d26362ab7a0e99f4" => :high_sierra
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
