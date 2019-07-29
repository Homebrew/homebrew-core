class Libserialport < Formula
  desc "Cross-platform serial port C library"
  homepage "https://sigrok.org/wiki/Libserialport"
  url "https://sigrok.org/download/source/libserialport/libserialport-0.1.1.tar.gz"
  sha256 "4a2af9d9c3ff488e92fb75b4ba38b35bcf9b8a66df04773eba2a7bbf1fa7529d"

  bottle do
    cellar :any
    sha256 "abe07f2865be280c550e14a3db11cf5c99e1cd469409379f045b8280831926d6" => :mojave
    sha256 "36dd828a2eba76bf82a3cd9c2c9ed9b684753c3a38aea33269f82f699762422b" => :high_sierra
    sha256 "e34159ce49ba7c90e2fc0672f99df7b11a6d2de9ceccfc20679918bb87cb9b1e" => :sierra
    sha256 "a2e2cb79d5a3774077c7458b0c131e67d345e8e7b2dc29735302d003fec3379e" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libserialport.h>
      int main() {
       struct sp_port *list_ptr = NULL;
       sp_get_port_by_name("some port", &list_ptr);
       return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lserialport",
                   "-o", "test"
    system "./test"
  end
end
