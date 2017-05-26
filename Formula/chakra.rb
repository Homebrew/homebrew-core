class Chakra < Formula
  desc "The core part of the Chakra JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.5.0.tar.gz"
  sha256 "acaa6e788f8e3defba7350c7ef7bac93ba6c31cca7cd821420725d5ab0151539"

  bottle do
    cellar :any
    sha256 "c99d26f04dbac1fce7f4ec6cae0db0d8e68f82666cfc2c6f32e91ea8fbe10deb" => :sierra
    sha256 "ecac360f3374d9a0cc57d30a9fba61f497c633a46bab6025479ee18c87ebb9bd" => :el_capitan
    sha256 "9595742613dec59fd0531b1033e769e2c237ce22ff83f5f3c44bd0601da11f95" => :yosemite
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
