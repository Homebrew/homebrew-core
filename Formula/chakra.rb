class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.8.5.tar.gz"
  sha256 "2feedbabf43fe6827859aae309ff64a69d09f25c6f09d2ecbc0808b0063fba9e"
  revision 1

  bottle do
    cellar :any
    sha256 "597d7758b329a31cc487cfa0a3476d7f860efc70c6a23647995b7f7bafefe7a8" => :high_sierra
    sha256 "7027a4dcc90c3ec9f4714f16c64ba99eb2804114a0a5b1aec53b6a60380b90a3" => :sierra
    sha256 "862ce77aef20520e7360f7fc64d06a997a7596f58e11562fc367eba562fb3298" => :el_capitan
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
