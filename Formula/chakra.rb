class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.12.tar.gz"
  sha256 "2f1289675c027d521ea1d3f64dd0bffe6e48f1cd9082d54ab14a6cb74ab4cc91"

  bottle do
    cellar :any
    sha256 "f2402d97955078324d36ec2dc685aca61b5f644619bf55c17eda12dd31e1c0bd" => :mojave
    sha256 "d65574d3271a6d698b1095038dc67263a57cf8592a9cfa0e0090739735d5d25a" => :high_sierra
    sha256 "0cb769df5cc902fd82f595998836caf1d73db3494bbb702a23a2e31c2b90705b" => :sierra
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
