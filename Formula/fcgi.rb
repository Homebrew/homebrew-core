class Fcgi < Formula
  desc "Protocol for interfacing interactive programs with a web server"
  # Last known good original homepage: https://web.archive.org/web/20080906064558/www.fastcgi.com/
  homepage "https://fastcgi-archives.github.io/"
  url "https://github.com/FastCGI-Archives/fcgi2/archive/2.4.2.tar.gz"
  sha256 "1fe83501edfc3a7ec96bb1e69db3fd5ea1730135bd73ab152186fd0b437013bc"

  bottle do
    cellar :any
    rebuild 1
    sha256 "54cfcdd18d640c947dca6c7d02eec6ef996ed6abd1cce93ec6d2265da7c56415" => :catalina
    sha256 "022ad3910de37e2713d9795bff3fc89d4562e4eeea218e9985023515478b980f" => :mojave
    sha256 "e3916280d172a68bd76bb57d6799e7557a5b0933949403cefd35ec722da89889" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"testfile.c").write <<~EOS
      #include "fcgi_stdio.h"
      #include <stdlib.h>
      int count = 0;
      int main(void){
        while (FCGI_Accept() >= 0){
        printf("Request number %d running on host %s", ++count, getenv("SERVER_HOSTNAME"));}}
    EOS
    system ENV.cc, "testfile.c", "-L#{lib}", "-lfcgi", "-o", "testfile"
    assert_match "Request number 1 running on host", shell_output("./testfile")
  end
end
