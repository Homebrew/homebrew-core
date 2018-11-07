class Libpointing < Formula
  desc "Provides direct access to HID pointing devices"
  homepage "https://github.com/INRIA/libpointing"
  url "https://github.com/INRIA/libpointing/releases/download/v1.0.7/libpointing-mac-1.0.7.tar.gz"
  sha256 "29f12da75727d1b03ff952a2754ce79b88aec39b5e03a52d3b0ff7440f08f147"

  bottle do
    cellar :any
    sha256 "c6057c63451e9913f0a7e5d55ca34282bd7da1d3e99bbc1452b267fb8d048a77" => :mojave
    sha256 "078c97a802303ac5db84dfe72ae189f1bd261c193612fbe36d9e92451da725c2" => :high_sierra
    sha256 "6ba8dbbb5a606a1e4b78512868986b80c4c3c971be04c90fbea59250dc6103ee" => :sierra
    sha256 "6ba8dbbb5a606a1e4b78512868986b80c4c3c971be04c90fbea59250dc6103ee" => :el_capitan
    sha256 "7120c106e54576154687dd63cdedb72633644e27213c7dbc1aa515a1227a8f3c" => :yosemite
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
