class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.3.tar.gz"
  sha256 "3f68b2cd4f7f4a4f343da7c2a52e6ef9ce4974a62faf3b834774a2033b3a6480"

  bottle do
    cellar :any
    sha256 "6d1aea67ac6ef0a7667bb3663a72850e7884b193d6c0b9eea984d5b5d94a0e49" => :mojave
    sha256 "608b7dd837abeef7d685b5477a82b19059b582d340040cc7eee12401e01a81dd" => :high_sierra
    sha256 "85ba321f85a1a13443ea7e6d31d1c6588c177f66035dc335c59af4ac60fd7520" => :sierra
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
