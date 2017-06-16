class Chakra < Formula
  desc "The core part of the Chakra JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.5.2.tar.gz"
  sha256 "4bb5c49539a7f6e41632288625cfaff86afe9319f18d88a5caa2c30c21e2bd23"

  bottle do
    cellar :any
    sha256 "4ba0bf84f6db1852decd1accf637f6933872179220fb6e5194c970e55d734539" => :sierra
    sha256 "0ff25d383b06acc50f4b25578f46a2d8ec9a57161fa0f8c7bd47e5b0f58f98a3" => :el_capitan
    sha256 "3d9ece5323b9655689ad75e0e02bdf4d82cfd91bc89c312467d0182993fbeb27" => :yosemite
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
