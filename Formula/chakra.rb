class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.8.5.tar.gz"
  sha256 "2feedbabf43fe6827859aae309ff64a69d09f25c6f09d2ecbc0808b0063fba9e"

  bottle do
    cellar :any
    sha256 "34ceb0ef3e31c8d79695ca819bd40eb22c4ad13716dc05864f9ebfbbb2c1e492" => :high_sierra
    sha256 "d39d06650bb49066d9cfda593ea6066b5c1449bd689e9040b40094a075fe9472" => :sierra
    sha256 "808344e21bcb5c58a88989a8f9779546eabd42b40336f29da04a06677f52d28c" => :el_capitan
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
