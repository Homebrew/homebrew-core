class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.5.tar.gz"
  sha256 "19c56dd55271919a66afcd56de94da3ed0e4b35ab9cd992ca57f4229148b0b88"

  bottle do
    cellar :any
    sha256 "e57aee095dedacc5e6bac0c9143f909b532ffa07fb09dbf17bbbaf0fdf8f3b2f" => :mojave
    sha256 "b88565f0bf70b963483e0b55da228e8a08e0b4614e43de525f5f05c4144c9344" => :high_sierra
    sha256 "6c786bab34409473d2cc118ffc249963f8b95ef1b413f3f9ca477b9bcfdd888d" => :sierra
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
