class Libpointing < Formula
  desc "Provides direct access to HID pointing devices"
  homepage "http://libpointing.org"
  url "https://github.com/INRIA/libpointing/releases/download/v0.9.7/libpointing-0.9.7.tar.gz"
  sha256 "254aca1da53c48952240a2f3b291d27117685a45f0f15dc6125c7b398de8e5da"

  bottle do
    cellar :any
    sha256 "468f8540342b346555595aa2b31223bf31ba719f589524bf513c00fa29938295" => :el_capitan
    sha256 "af6c98bd030f2bdeae5840d87ea5ed06a41c8c26d99e7132a5d33087cceeea48" => :yosemite
    sha256 "64e2741c4fbe47d0db4e08bcc5ac7b9e46bd3716eef661e88326945deed15e1b" => :mavericks
  end

  def install
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
    system ENV.cxx, "test.cpp", "-lpointing", "-o", "test"
    system "./test"
  end
end
