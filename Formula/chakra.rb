class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.18.tar.gz"
  sha256 "20b0a468aabde898669eed5d65ff83eadc29c4ca9d88f512e97de91761f092f1"

  bottle do
    cellar :any
    sha256 "9b0c717f196ad4f7d3552513c6198a3941f6f11cdabf2f90f9489c29874560bc" => :catalina
    sha256 "d6f974be85cf989abbba743d4a4942390ea6aa59b91a24eb5258cd7d6326ebad" => :mojave
    sha256 "50a8aac3fa4df2883577655ce73edcefdaff0d552ebbedb28bfc0309c8782698" => :high_sierra
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
