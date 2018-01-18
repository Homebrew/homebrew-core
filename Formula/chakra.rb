class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.8.0.tar.gz"
  sha256 "af85cf9c1f3a32fef0f586842f468bf18158567c4b098b0a917bde7b386b90cc"

  bottle do
    cellar :any
    sha256 "b926a9cdc8d6a49359a4cd46116e60b6ce941838f689fc0c14f8c36f0c539586" => :high_sierra
    sha256 "615b64319a580cc80a209ed8fc0cb4cfc959474984581f240c3c3b4a246c84f3" => :sierra
    sha256 "cd945c514977ab44816df5f390aedfa9ebf950528be7f53620b952f779d6a142" => :el_capitan
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
