class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.8.2.tar.gz"
  sha256 "fd5336a1baab8accd7f395f56af7347a70f755f7db46fbf8a8efaffa3eb73243"

  bottle do
    cellar :any
    sha256 "bb134d70d56566e5957d82b26cfdada441de5ed52f6dc1922d0032ead94414a9" => :high_sierra
    sha256 "167b0bb08f060c5f7170acfd95401b7e6046702dbb9f1027b2a184fff2ec3f00" => :sierra
    sha256 "9b44c49e8e86b61e90c7eb5f17eb22bdce1f60daffcad230ad04a2cc06a10415" => :el_capitan
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
