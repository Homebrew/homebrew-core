class Libpointing < Formula
  desc "Provides direct access to HID pointing devices"
  homepage "http://libpointing.org"
  url "https://github.com/INRIA/libpointing/releases/download/v1.0.4/libpointing-mac-1.0.4.tar.gz"
  sha256 "2218beccc1b7b3f5df6b6a9f6fc14e9673d7215726c7c15c7daf66c1ac7ad729"

  bottle do
    cellar :any
    sha256 "e85c6daf643bcac5dc4309fae77d2105a42cf6b4e1bd7c95445464f3149839c2" => :sierra
    sha256 "91b34da1f57b2988b08c157720e257e4c9048d5bbde26c21468c6d187a4fbd43" => :el_capitan
    sha256 "d8bebe09c71a6ddd66d3c03c9b5aacf58ceb8faa475746690931783718116944" => :yosemite
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
