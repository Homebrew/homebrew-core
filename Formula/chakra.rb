class Chakra < Formula
  desc "Core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.24.tar.gz"
  sha256 "b99e85f2d0fa24f2b6ccf9a6d2723f3eecfe986a9d2c4d34fa1fd0d015d0595e"
  license "MIT"

  bottle do
    cellar :any
    sha256 "027ab48bc0f22c7fbf27bdf3a2cf5b78f4d4413827a84938f4f907e0453de691" => :big_sur
    sha256 "4ebad6a8d8e47a4a8cccc50d732a37e599f611159a5c1b8862e2950478b5590d" => :catalina
    sha256 "9c5adf858fb4b0ca2d1965176d4e9d2f73849457fbd69e2b9110798b73235130" => :mojave
    sha256 "f20f76e4e0c66d9ae70c241d3fcc49eb48518820eabd50a51f29f640a4c67305" => :high_sierra
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
