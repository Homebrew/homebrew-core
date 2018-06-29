class Chakra < Formula
  desc "The core part of the JavaScript engine that powers Microsoft Edge"
  homepage "https://github.com/Microsoft/ChakraCore"
  url "https://github.com/Microsoft/ChakraCore/archive/v1.10.0.tar.gz"
  sha256 "1d1ad8e930219a382d9dafd25e1d5b9eaabeb6c620fdb6798aaececffe092f0f"

  bottle do
    cellar :any
    sha256 "1fe946e441cf872527d622ffa4cc2595fa40c97491233a22f73da0566a94424c" => :high_sierra
    sha256 "aa61b522730a12655d83a472164986910f8e8c5a35bfff15a245f5e6c36bf110" => :sierra
    sha256 "4e06770faa3e140ce3f3f5da433d0276efbce8caef10d11549341ddca0e7c9a0" => :el_capitan
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
