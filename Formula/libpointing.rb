class Libpointing < Formula
  desc "Provides direct access to HID pointing devices"
  homepage "http://libpointing.org"
  url "https://github.com/INRIA/libpointing/releases/download/v1.0.3/libpointing-mac-1.0.3.tar.gz"
  sha256 "0c0461bb7470595650fd34735283a21ba7fafe9e476887ef8e63b7b35c040e90"

  bottle do
    cellar :any
    sha256 "2fa16b6c03d0e36f59ce686ab327cc949d0970b9d79e8f3e6c0f4bf7069e5756" => :sierra
    sha256 "2fa16b6c03d0e36f59ce686ab327cc949d0970b9d79e8f3e6c0f4bf7069e5756" => :el_capitan
    sha256 "a69e8fb6eb703b0f190cc10e2dc121d94d33be4b5499e43d740fbf4ba60535c0" => :yosemite
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <pointing/pointing.h>
      #include <iostream>
      int main() {
        std::cout << LIBPOINTING_VER_STRING << " |" ;
        std::list<std::string> schemes = pointing::TransferFunction::schemes() ;
        for (std::list<std::string>::iterator i=schemes.begin(); i!=schemes.end(); ++i) {
          std::cout << " " << (*i) ;
        }
        std::cout << std::endl ;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lpointing", "-o", "test"
    system "./test"
  end
end
