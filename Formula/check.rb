class Check < Formula
  desc "C unit testing framework"
  homepage "https://libcheck.github.io/check/"
  url "https://github.com/libcheck/check/releases/download/0.11.0/check-0.11.0.tar.gz"
  sha256 "24f7a48aae6b74755bcbe964ce8bc7240f6ced2141f8d9cf480bc3b3de0d5616"

  bottle do
    cellar :any
    sha256 "ab001aa687f2a1f18df5c8765086a3300d989d600a7895c8a2c8efd2242f62a1" => :sierra
    sha256 "2e37bca055ae0bf490b713d90c95a9d81518cae9b884a7e495f521c80b4f062f" => :el_capitan
    sha256 "bb824d8cb8a74ebbc1eb9d22b8ea15327dfe3ce91151b37c7f41c80939609f52" => :yosemite
    sha256 "022667ec28a8af0bf6e19f3afbaa144542f1754ebaff5710229484fa8071084e" => :mavericks
    sha256 "b223c76b5519c5aa3300488b230c5b5b2cbd32d896f2fab0f1a0700a24e1f975" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.tc").write <<-EOS.undent
      #test test1
      ck_assert_msg(1, "This should always pass");
    EOS

    system "#{bin/"checkmk"} test.tc > test.c"

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcheck", "-o", "test"
    system "./test"
  end
end
