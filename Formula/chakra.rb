class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.0.tar.gz"
  sha256 "f76a775630cf4e2a6132ef77839b7b2a28ba36adbbd86dd24a806bf7dc176538"

  bottle do
    cellar :any
    sha256 "4543a2fcb524e018a86a41509936687172e17b37bcef142f175a62b55a3d9c65" => :high_sierra
    sha256 "e11fc6294e3f0996b0b37b41ca9ffcbc4a11aa9b151c3a7ea8ce04aba1ffe065" => :sierra
    sha256 "fe9ea30ea4de880f04242e4753b45c93e7774f3da9bcc0c847119ff046bd25f1" => :el_capitan
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
