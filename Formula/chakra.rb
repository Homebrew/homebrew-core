class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.8.3.tar.gz"
  sha256 "c4664eecffd34c32d8f5dd62f4956e309eede678b95540b496b6893b05725a97"

  bottle do
    cellar :any
    sha256 "ffca938f423700f3edacdfaae4ff7a21f03071e49750c8a8dd8aa33063c98e8c" => :high_sierra
    sha256 "2b6d8c02c4fc3e8f46998d78c44a5445805cd90ebdbc8450658d57a6253b5d5b" => :sierra
    sha256 "215ba49491d4008c96a6f13b87a03755a77381e01b1ae38a00fa192d31e34106" => :el_capitan
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
