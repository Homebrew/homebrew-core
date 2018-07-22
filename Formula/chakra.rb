class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.10.1.tar.gz"
  sha256 "3c281b273c26017a539eed74301430a82c2e74714cdbc5e1c50e9521f603f56f"

  bottle do
    cellar :any
    sha256 "12db99547edbe917bb9eef4ea7499e94fcadafeca872296ff0fd034bb8fc0be3" => :high_sierra
    sha256 "8c40e38100c922a8da2024c9e93a932598cadc3d3aac5519b8eab8124f2bb70c" => :sierra
    sha256 "7eaa1f07d5a040c44bc5178b88a3dfc5b3d167ce9d30ce536de9a0007b2ea77a" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "icu4c"

  def install
    system "./build.sh", "--lto-thin",
                         "--static",
                         "--icu=#{Formula["icu4c"].opt_include}",
                         "--extra-defines=U_USING_ICU_NAMESPACE=1", # icu4c 61.1 compatability
                         "-j=#{ENV.make_jobs}",
                         "-y"
    bin.install "out/Release/ch" => "chakra"
  end

  test do
    (testpath/"test.js").write("print('Hello world!');\n")
    assert_equal "Hello world!", shell_output("#{bin}/chakra test.js").chomp
  end
end
