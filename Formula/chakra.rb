class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.6.tar.gz"
  sha256 "14a6adc9b14cf383e636c8a63f94590cc0fc4ab233e82110fe63039d8acb41b8"

  bottle do
    cellar :any
    sha256 "6195d3ff8330aaa05ca628a458c61161ea3c728ece80509d7ebceb26c0f519e0" => :mojave
    sha256 "537ef009ab058730f68b17a4a3cda2b2bd70c29dd25368a5938aa5e861bcabfe" => :high_sierra
    sha256 "30fc22a9ac5db7fc879ac418d46b89021edff8e316f167407359bc8157f89451" => :sierra
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
