class Chakra < Formula
  desc "The core part of the Chakra JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.5.0.tar.gz"
  sha256 "acaa6e788f8e3defba7350c7ef7bac93ba6c31cca7cd821420725d5ab0151539"

  bottle do
    cellar :any_skip_relocation
    sha256 "fdd4e4dd04846af48290e70ab3cc12ec5d268e2443e2e2008c88f388fba14c22" => :sierra
    sha256 "05da27ee145e09cbd81c7c24e15fba44fd469c14139778402aa5ba7fe4752c9e" => :el_capitan
    sha256 "e1446136769d178a0be96743024ae6d8b22f49b7caa8499a9f7a1be6350b45fb" => :yosemite
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
