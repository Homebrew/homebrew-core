class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.7.1.tar.gz"
  sha256 "ba196ecb451fd4382b84d854fe6a462031ccf87bfd681db2543c0a8a61ba1b3c"
  revision 1

  bottle do
    cellar :any
    sha256 "325d1c68180c89cb0a62b0d25fe05bf9b86a14279dac338fa80a3b09e812fdb4" => :sierra
    sha256 "9bc7de1f6c585d3cd2d97e9f44af1eee71521cf3394ab5af28e28249d45a23d1" => :el_capitan
    sha256 "503a0362f8e438144150836cd2b0266f7020292967d1c998016c6979b3990aa0" => :yosemite
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
