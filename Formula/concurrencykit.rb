class Concurrencykit < Formula
  desc "Aid design and implementation of concurrent systems"
  homepage "http://concurrencykit.org"
  url "http://concurrencykit.org/releases/ck-0.5.2.tar.gz"
  mirror "https://github.com/concurrencykit/ck/archive/0.5.2.tar.gz"
  sha256 "5cf44b33f9279c653ec9b2b085d628c86336e4da18897be449f074283e5c5b3a"

  head "https://github.com/concurrencykit/ck.git"

  bottle do
    cellar :any
    sha256 "84b9e7044b51c5ff9312a0b7b2237ed1c790033725d826e71444e74c84a01e9c" => :sierra
    sha256 "77f8ad1f44e7f018e17040ffa144e8cc279ec39e9db47e348a84d0631d638d83" => :el_capitan
    sha256 "c981b82030b838517ca87d261cf160eb141ba91fcede5b68583c4a1b26c4b864" => :yosemite
    sha256 "a45619fb3062e79e786b16839de5ebd6b8abe33e004092309d535b17cb90ea2e" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <ck_spinlock.h>
      int main()
      {
          return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lck",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
