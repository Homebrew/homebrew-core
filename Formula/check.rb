class Check < Formula
  desc "C unit testing framework"
  homepage "https://libcheck.github.io/check/"
  url "https://github.com/libcheck/check/releases/download/0.15.0/check-0.15.0.tar.gz"
  sha256 "aea2e3c68fa6e1e92378e744b1c0db350ccda4b6bd0d19530d0ae185b3d1ac60"

  bottle do
    cellar :any
    sha256 "dbc7dd0d84f86a9ad3813a4ad45b076903120f0e3d0cb949c46f2dfc448e7d3c" => :catalina
    sha256 "9820eed7640c7e834672ea0a378b37ebc8825b0513de1b06b6321eb51c799686" => :mojave
    sha256 "f1f7a1f81a08235f922124a0e833fd9862e9e53931c5113ad543b42c4636a2b6" => :high_sierra
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
