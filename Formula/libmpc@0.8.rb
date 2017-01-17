class LibmpcAT08 < Formula
  desc "C library for high precision complex numbers"
  homepage "http://multiprecision.org"
  # Track gcc infrastructure releases.
  url "http://multiprecision.org/mpc/download/mpc-0.8.1.tar.gz"
  mirror "ftp://gcc.gnu.org/pub/gcc/infrastructure/mpc-0.8.1.tar.gz"
  sha256 "e664603757251fd8a352848276497a4c79b7f8b21fd8aedd5cc0598a38fee3e4"

  bottle do
    cellar :any
    sha256 "640ac5352ddd744e5e35cd15e1c5b6301bfda1c60b1432c22c4a9af7c93fe674" => :sierra
    sha256 "d52fb9281d199704c43f57b9496be69d1a45ed77d5f179928c27bf800a343698" => :el_capitan
    sha256 "51be960a907bb34a89c13b3db80260fcb6c4ffa55ca2ac2e797615d71a02fde6" => :yosemite
  end

  keg_only "Older version of libmpc"

  depends_on "gmp@4"
  depends_on "mpfr@2"

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-dependency-tracking",
      "--with-gmp=#{Formula["gmp@4"].opt_prefix}",
      "--with-mpfr=#{Formula["mpfr@2"].opt_prefix}",
    ]

    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <mpc.h>

      int main()
      {
        mpc_t x;
        mpc_init2 (x, 256);
        mpc_clear (x);
        return 0;
      }
    EOS
    gmp = Formula["gmp@4"]
    mpfr = Formula["mpfr@2"]
    system ENV.cc, "test.c",
      "-I#{gmp.include}", "-L#{gmp.lib}", "-lgmp",
      "-I#{mpfr.include}", "-L#{mpfr.lib}", "-lmpfr",
      "-I#{include}", "-L#{lib}", "-lmpc",
      "-o", "test"
    system "./test"
  end
end
