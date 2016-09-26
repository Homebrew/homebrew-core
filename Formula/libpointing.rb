class Libpointing < Formula
  desc "Provides direct access to HID pointing devices"
  homepage "http://libpointing.org"
  url "https://github.com/INRIA/libpointing/releases/download/v1.0.2/libpointing-mac-1.0.2.tar.gz"
  sha256 "4f4234581772bace7e811da1643d53922d8e29efdb52a5a6d7aaa13c937159f1"

  bottle do
    cellar :any
    sha256 "079457c310c4f84832e1c64c25a1067de993b87b7fab4eafb6202549ee2a4940" => :sierra
    sha256 "079457c310c4f84832e1c64c25a1067de993b87b7fab4eafb6202549ee2a4940" => :el_capitan
    sha256 "438b00adce6f408749c9ab874c296b54b48df89d89b27bbc691204fb8cd9cad1" => :yosemite
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
