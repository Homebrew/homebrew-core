class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.16.tar.gz"
  sha256 "81429055e51a786079002d33d3eae58771f8b7c383b3f47991d63e5be84a7f4d"

  bottle do
    cellar :any
    sha256 "d33ba43882f7f50e14b6923ddea459f7153c006373b1846bf25232c0ad66e33b" => :catalina
    sha256 "d031cef051330c7924d2201ca22c6e80f0cd11da86f684c2f1ce984e6748655e" => :mojave
    sha256 "b91f54c71fa0d48d12f29bd7a77cedf4ba428c2615e2ae607c9f140aa6343b05" => :high_sierra
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
