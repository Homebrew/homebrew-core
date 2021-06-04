class Chakra < Formula
  desc "Core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.24.tar.gz"
  sha256 "b99e85f2d0fa24f2b6ccf9a6d2723f3eecfe986a9d2c4d34fa1fd0d015d0595e"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any, big_sur:  "e89bbc179ff9477dcf8589c6b8ac1caedd528f1a4247cb66f20f5af2e3544421"
    sha256 cellar: :any, catalina: "44f4599ea428559b326091374b7d0bcbcf987496f40e513b9cd4fffba7576d37"
    sha256 cellar: :any, mojave:   "8e7489e2c043d1669446d5743352ed36ed72a94d8fc9c1bb5e2b666ab404c450"
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
