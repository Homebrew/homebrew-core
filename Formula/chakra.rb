class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.0.tar.gz"
  sha256 "f76a775630cf4e2a6132ef77839b7b2a28ba36adbbd86dd24a806bf7dc176538"

  bottle do
    cellar :any
    sha256 "4d8d0b542398ca8a510374e4cb6702f1e9bbc0533cacf589088a6b312caca879" => :mojave
    sha256 "e7f1fa4ced218d0069e019358e63394ff0515f4489bcd74c49d45351e15ce7f0" => :high_sierra
    sha256 "fc1ad91a954263720f3fa0d47e367208a4d7791bf58d922e6dc40f5de0cae72e" => :sierra
    sha256 "3f6ee063e19dc68ae05df4476b12272cc170369bec5ec152b3bded2b7cf7c89b" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "icu4c"

  # Teach the build script to recognise LLVM 10+/Clang 1000 as valid.
  # Merged upstream but not yet in 1.11.0; check again next release.
  patch do
    url "https://github.com/Microsoft/ChakraCore/commit/559d432087ea9f6ff92574b618194d7a06d12c41.patch?full_index=1"
    sha256 "05b80e18a3e70f33ee7442a9c2b236c71e74970ba35b25817147e5e0b6ccd140"
  end

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
