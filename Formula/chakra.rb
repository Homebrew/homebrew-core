class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.2.tar.gz"
  sha256 "566481c5dd6fbfff80165374ca1ad84f84e24e634596a7dd6f8cceccc86dd47c"

  bottle do
    cellar :any
    sha256 "45d0fd0700d71d902e45253d97b7348e908096733c4afa6ae988f5631b1033b5" => :mojave
    sha256 "bc37a40881309b04e0ecdad2453b8862228e8c2f200983daa982e99f2761d3ba" => :high_sierra
    sha256 "fa158900b2302e02e788fd9c8e3c81ae1813449269c01c8adc25695577b6c5bc" => :sierra
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
