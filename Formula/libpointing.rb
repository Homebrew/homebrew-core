class Libpointing < Formula
  desc "Provides direct access to HID pointing devices"
  homepage "http://libpointing.org"
  url "https://github.com/INRIA/libpointing/releases/download/v1.0.7/libpointing-mac-1.0.7.tar.gz"
  sha256 "29f12da75727d1b03ff952a2754ce79b88aec39b5e03a52d3b0ff7440f08f147"

  bottle do
    cellar :any
    sha256 "2a5872ff291d43b625fc54d5321efb011886e3f0609511628f0c8491babe4ae7" => :sierra
    sha256 "2a5872ff291d43b625fc54d5321efb011886e3f0609511628f0c8491babe4ae7" => :el_capitan
    sha256 "1cbd53dbdd74c4e52dc88e706f9efa84bec9de9e25435db6a445f821e4e70b5a" => :yosemite
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
