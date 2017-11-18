class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.7.4.tar.gz"
  sha256 "13bf88e4d5618d1706ef2c2456bfbffa56726ae0f3b3640b5a8774bb5c27a83d"

  bottle do
    cellar :any
    sha256 "5010ade4fed3ead0ceb5ccbfa053c84df0893ed0fc0fea400feab9504813a3f5" => :high_sierra
    sha256 "70a9692d9b9fafd0f38403a1cb174d933cb22e3676bde099da08ccde30e8b4db" => :sierra
    sha256 "a4bc47700b7c867e8cf67a64704695e1a16e0fa4286bf2c38f3576d9d8d03f46" => :el_capitan
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
