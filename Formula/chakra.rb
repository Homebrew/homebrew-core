class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.7.1.tar.gz"
  sha256 "ba196ecb451fd4382b84d854fe6a462031ccf87bfd681db2543c0a8a61ba1b3c"

  bottle do
    cellar :any
    sha256 "87b118a93f13fa3a574a55a5a7fa6ba13da6b38bae940ade8e024752a66d592e" => :sierra
    sha256 "8e941eab8dcc9d14ec8e22da5456fff5fedd4b6a965b9dfdd2ba31fe74648343" => :el_capitan
    sha256 "d01cb6d79d2072d189b1a6174df208378532eb98dace23c4461426e81a232266" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "icu4c"

  def install
    system "./build.sh", "--lto-thin", "--static", "--icu=#{Formula["icu4c"].opt_include}", "-j=#{ENV.make_jobs}", "-y"
    bin.install "out/Release/ch" => "chakra"
  end

  test do
    (testpath/"test.js").write("print('Hello world!');\n")
    assert_equal "Hello world!", shell_output("#{bin}/chakra test.js").chomp
  end
end
