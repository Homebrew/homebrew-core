class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.18.tar.gz"
  sha256 "20b0a468aabde898669eed5d65ff83eadc29c4ca9d88f512e97de91761f092f1"
  revision 1

  bottle do
    cellar :any
    sha256 "28ef3a83db9f3290afe6c15a7e3622300dcc3455bfecef0b61a0670afbc80af7" => :catalina
    sha256 "8d99fab1eee9fc0498049f34516fc9e6f5ef18bfae528a4b7dbf48ae44fc25fa" => :mojave
    sha256 "6f39c4d4f8a4416ba8210cd0aab579835fe5436d7cf8a7095bac40976d4a962a" => :high_sierra
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
