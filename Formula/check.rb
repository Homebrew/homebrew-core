class Check < Formula
  desc "C unit testing framework"
  homepage "https://libcheck.github.io/check/"
  url "https://github.com/libcheck/check/releases/download/0.15.1/check-0.15.1.tar.gz"
  sha256 "c1cc3d64975c0edd8042ab90d881662f1571278f8ea79d8e3c2cc877dac60001"

  bottle do
    cellar :any
    sha256 "9a2dfdb90114246c471c4b9c8d4d9d54d0d4ecc92763ecd51ab3bf7a311134ef" => :catalina
    sha256 "612c2b1f5ca586475d1c6aaa24855fa415bb124a39b0df8c5f6532f49040d75a" => :mojave
    sha256 "d9e41cd93513d74aeeb364f11556930410276e828da8861212a27225614e5cee" => :high_sierra
  end

  on_linux do
    depends_on "gawk"
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
