class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.11.19.tar.gz"
  sha256 "db21584c5b557af622e6fc45e97e80ae579a0e33805ffb123dea2ddaf36b4dae"

  bottle do
    cellar :any
    sha256 "783559111c384e75dd5baebd6afd767a874b8a254be97462f4065b536e8ba564" => :catalina
    sha256 "0798d7fa1736d966c9f4e052ea106618411819e80f09fc7c340363a06f6b81e1" => :mojave
    sha256 "83cb40985ea19d210deb266dc1e3a8e4ffa3809be329eed77dca51e797b7f40a" => :high_sierra
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
