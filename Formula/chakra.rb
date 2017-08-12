class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.7.1.tar.gz"
  sha256 "ba196ecb451fd4382b84d854fe6a462031ccf87bfd681db2543c0a8a61ba1b3c"
  revision 1

  bottle do
    cellar :any
    sha256 "e6eac7c473c49e946b4f5d41d7294a3dcf79521edd1af083ef1cd531309cdd9f" => :sierra
    sha256 "41ef4bbc798ee2705065c4b0cd044d064aa3a45e2c7afb738101c9c615cbbaab" => :el_capitan
    sha256 "269a412320bb55f98f6260057464ca6433ebce9134d836de2d6dadc3a034c206" => :yosemite
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
