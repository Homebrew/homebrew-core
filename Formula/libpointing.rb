class Libpointing < Formula
  desc "Provides direct access to HID pointing devices"
  homepage "http://libpointing.org"
  url "https://github.com/INRIA/libpointing/releases/download/v0.9.7/libpointing-0.9.7.tar.gz"
  sha256 "254aca1da53c48952240a2f3b291d27117685a45f0f15dc6125c7b398de8e5da"

  bottle do
    cellar :any
    sha256 "f8a394a1901f5b9966a9e95ad53dd357e10b92964048b13f36bdd088e966ab71" => :el_capitan
    sha256 "5d08d3684ee51ce7bd9fb5fc845e62440a8d976e3753fb247db5c81c6414c1c9" => :yosemite
    sha256 "01fe35550fe5b4a6847744cd6bca035083f0bb11366948ad5bc1a0a8f922399a" => :mavericks
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
