class Chakra < Formula
  desc "Core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.24.tar.gz"
  sha256 "b99e85f2d0fa24f2b6ccf9a6d2723f3eecfe986a9d2c4d34fa1fd0d015d0595e"
  license "MIT"
  revision 1

  bottle do
    cellar :any
    sha256 "54835c87297a98ea9edb65a60d47b82f6e67b5207d1297e04bf23a41a9eea597" => :big_sur
    sha256 "594b400cd30d5ee359237573099b6243d0f76d46045878de712b7b15572a222d" => :catalina
    sha256 "8597fc787f82f99e48303c40bec65cd41c31347be6c8da8478eabb723e3f1a37" => :mojave
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
