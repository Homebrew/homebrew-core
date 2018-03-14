class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.8.2.tar.gz"
  sha256 "fd5336a1baab8accd7f395f56af7347a70f755f7db46fbf8a8efaffa3eb73243"

  bottle do
    cellar :any
    sha256 "2c8e7bae5fb79b850142a62ac7152fc946a2528d5cfce50fb0a86ca65b3d5a0d" => :high_sierra
    sha256 "f7bbd73201d15b2754912b32b290186c5c04c6ceab3defc0161e8f79e31cd7a6" => :sierra
    sha256 "b34c2fbf1f23871eb19aac69bb908b157abcf5b43d1f1159abb5bb24bd068bb7" => :el_capitan
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
