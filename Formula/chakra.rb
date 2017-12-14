class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.7.5.tar.gz"
  sha256 "3458224adeaf2de58e545ccc5b3da06a5b12c8e2bfd5c49be5c15a90c799265c"
  revision 1

  bottle do
    cellar :any
    sha256 "2f90710f513fea7868f0f2950efc6c1bb52a7890b21d134f379a8e4a6bd23aad" => :high_sierra
    sha256 "b858aadf0e9fc17a21b3fa2599642122ad17f64a7b60a82b0e6c181e005da3b2" => :sierra
    sha256 "db8fdb7769d068d1137f3ab6b9b33b9fccd64dd93a880f8f3a708c9f4f07a939" => :el_capitan
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
