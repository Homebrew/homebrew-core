class Libpointing < Formula
  desc "Provides direct access to HID pointing devices"
  homepage "http://libpointing.org"
  url "https://github.com/INRIA/libpointing/releases/download/v1.0.2/libpointing-mac-1.0.2.tar.gz"
  sha256 "4f4234581772bace7e811da1643d53922d8e29efdb52a5a6d7aaa13c937159f1"

  bottle do
    cellar :any
    sha256 "de1d173635b27a61e49d3b10f85158fe48ed90bc2e235dd3705050156718cecd" => :el_capitan
    sha256 "bb7bd0b800f29ef958bb7e91ff53929533636403f28d318ff414b0511e05247d" => :yosemite
    sha256 "5b3a242b4e1db437c826c18f6daa44f50af66b928202d9ffa326019aa436bbde" => :mavericks
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
