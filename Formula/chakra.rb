class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.5.tar.gz"
  sha256 "19c56dd55271919a66afcd56de94da3ed0e4b35ab9cd992ca57f4229148b0b88"

  bottle do
    cellar :any
    sha256 "e91827363894161af817c6c5c8b9b0d9ae6893e73663551e4422513a2e973bc3" => :mojave
    sha256 "b3bb191c53b88fc5b60f59a4f6707752e5547119040dfe0cf24b9f78d5fc88fb" => :high_sierra
    sha256 "cc90599c589f9336be7de3650cc5b08f66a2df8572eac48e30141ba15c2f0e59" => :sierra
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
