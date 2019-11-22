class Libpointing < Formula
  desc "Provides direct access to HID pointing devices"
  homepage "https://github.com/INRIA/libpointing"
  url "https://github.com/INRIA/libpointing/releases/download/v1.0.8/libpointing-mac-1.0.8.tar.gz"
  sha256 "b19a701b9181be05c3879bbfc901709055c27de7995bd59ada4e3f631dfad8f2"

  bottle do
    cellar :any
    sha256 "d56d66f5df0d6e1c80cc4e4951e8add9cbb0c5fb76080c9107f66665b8b46e48" => :catalina
    sha256 "adecdbec3a556dfd78dd1aa24f6868814fc4b3243310311192fee4e9de912c62" => :mojave
    sha256 "97e7550c8e3c3007df96cc98eab35a297ed857a6fd1bc24011d1dea8350966e5" => :high_sierra
    sha256 "1fc9b4bdab762eb8f93c4a75c57e82b14f3274186f5185fa9a17e8d0f3bc3452" => :sierra
  end

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
