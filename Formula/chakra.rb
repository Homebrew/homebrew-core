class Chakra < Formula
  desc "The core part of the Chakra JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.5.2.tar.gz"
  sha256 "4bb5c49539a7f6e41632288625cfaff86afe9319f18d88a5caa2c30c21e2bd23"

  bottle do
    cellar :any
    sha256 "52a64388df79d565212abe7647c597fcd4a3a75f15b01bc6acc05ede21581002" => :sierra
    sha256 "9f4061224a5256cc327833eb88e4ece096121e8d2a98d495135327695b85937b" => :el_capitan
    sha256 "3ffeef45f08398d7ae8eb1cdf8bb51f393794e589b8ba895bb81788e83602e4b" => :yosemite
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
