class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.8.4.tar.gz"
  sha256 "1a51bdd4e3f5d363b3f68bf947f114a4822ab6c45d062df5ab2050f76944fb56"

  bottle do
    cellar :any
    sha256 "83fdc2345ec8b69b2ab99162c59c88229ab8af8763e89448eb64cedb1d622664" => :high_sierra
    sha256 "0c59743b3e0a15edf5c7eee598bb8f5eaecc482b37b34531be689bcad352e599" => :sierra
    sha256 "ce6b2463ddb6a39a2f0d98288913fb54327bd813fb0b9df0c9d156badb6e81c4" => :el_capitan
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
