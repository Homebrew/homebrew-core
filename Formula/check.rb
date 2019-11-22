class Check < Formula
  desc "C unit testing framework"
  homepage "https://libcheck.github.io/check/"
  url "https://github.com/libcheck/check/releases/download/0.13.0/check-0.13.0.tar.gz"
  sha256 "c4336b31447acc7e3266854f73ec188cdb15554d0edd44739631da174a569909"

  bottle do
    cellar :any
    sha256 "7e43575b92dbfe052ea8eee6f488799faa6c9e0a411040b10b0734cc3f50e375" => :catalina
    sha256 "7ceb61ee5e716184068334f62a40c708270f88e7e0709e7d464eefd71366d272" => :mojave
    sha256 "12147cd97f24af6c18fa393200f063e1d24ea95ffbd1b29cb2dd1f2a4f8ef24b" => :high_sierra
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
