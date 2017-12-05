class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.7.4.tar.gz"
  sha256 "13bf88e4d5618d1706ef2c2456bfbffa56726ae0f3b3640b5a8774bb5c27a83d"
  revision 1

  bottle do
    cellar :any
    sha256 "962e77109b7e867db90a53735d2dc472c6a5d5e54c8a34972d7b981907e34eb8" => :high_sierra
    sha256 "81123d7112e36187542be756f265ded709b0fa371bb3cabb5ae4a8c3069b1f02" => :sierra
    sha256 "a20f68d6172282b53f815a759ff0204ebf679a003fd04209bf0276b07c37e9d2" => :el_capitan
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
