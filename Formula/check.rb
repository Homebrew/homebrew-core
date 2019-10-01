class Check < Formula
  desc "C unit testing framework"
  homepage "https://libcheck.github.io/check/"
  url "https://github.com/libcheck/check/releases/download/0.12.0/check-0.12.0.tar.gz"
  sha256 "464201098bee00e90f5c4bdfa94a5d3ead8d641f9025b560a27755a83b824234"

  bottle do
    cellar :any
    sha256 "b33db26bf660192460c8ce4d53efcfa3a0ad60b5cb139f495157c444841ca1cb" => :catalina
    sha256 "57498a48acaa07afcea73fc831986e4dbd8dd8742d35a600e6bbe3f328c32f08" => :mojave
    sha256 "fd175fded31ecc36ad06beeb18e05fd4d5f5bc538e1a445e86b703bf34373fd8" => :high_sierra
    sha256 "6ad1ff9e52d767968efb2b73b563b171561421818a86185c03639f65f0a22ab3" => :sierra
    sha256 "5de09e615daf7e12f1b10485b7bc8cb5382e04f856dc516056bae0a30b5f6b49" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.tc").write <<~EOS
      #test test1
      ck_assert_msg(1, "This should always pass");
    EOS

    system "#{bin/"checkmk"} test.tc > test.c"

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcheck", "-o", "test"
    system "./test"
  end
end
