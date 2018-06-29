class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.10.0.tar.gz"
  sha256 "1d1ad8e930219a382d9dafd25e1d5b9eaabeb6c620fdb6798aaececffe092f0f"

  bottle do
    cellar :any
    sha256 "4976439073daa93b080626632687aa0dccfbbb486e86464409a0a8060349f66e" => :high_sierra
    sha256 "2e497df484f75df4069f52a4796f047043821dd597184944dbb0fb4a6e40943e" => :sierra
    sha256 "c14bde48c5a96a15b0362744228a2b85219d12e770d567abacfe17305090bf61" => :el_capitan
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
