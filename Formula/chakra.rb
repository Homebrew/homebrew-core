class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.10.2.tar.gz"
  sha256 "702ef581509e0eb9bdf55e6cdb9e268d32246bca1678291a5ff6f764d8749355"

  bottle do
    cellar :any
    rebuild 1
    sha256 "302d4be69e82c5759960f0c19681a349422d5070cd037917396cbd7e0141edf1" => :high_sierra
    sha256 "8b71442aab93b347b16f80aef26ce07890aa64accff20b16b7edd25e3f22f9d0" => :sierra
    sha256 "9078248ffe4c54c5f1268db704e6312f0e97ffe973e21c00c6cb30f66a6ce992" => :el_capitan
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
