class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.4.tar.gz"
  sha256 "3b5163d9baa1c85ad6ae296b9e9522ff7dfcb9d3f8660059b919f1f387e15b98"

  bottle do
    cellar :any
    sha256 "43a2d32f24ed421b2361dad64f0ee163d860dda44732b1d36a67a9eef674c9ab" => :mojave
    sha256 "c0923046a4314d26ea18a2095cf0de3b0a4743a6dab240014c66933f1c7e55d7" => :high_sierra
    sha256 "19bae5cb79c22e197da0eb576e8c55189671ba2aae1a0a4fd77fff1ebdb8aae3" => :sierra
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
