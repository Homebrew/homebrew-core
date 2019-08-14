class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.12.tar.gz"
  sha256 "2f1289675c027d521ea1d3f64dd0bffe6e48f1cd9082d54ab14a6cb74ab4cc91"

  bottle do
    cellar :any
    sha256 "a408ee40c043aa315de36d7783eab010cad12897309380ae5bcaf54225f6d8c5" => :mojave
    sha256 "cb7b188d2b809d2ba5c445b5f3d94521a3c986a5e8f95ab4c135c892893a921c" => :high_sierra
    sha256 "485c67b6124d543389230f0b7224cb9fce27f5abfc063f315f74ec094244491a" => :sierra
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
