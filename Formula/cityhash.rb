class Cityhash < Formula
  desc "Hash functions for strings"
  homepage "https://github.com/google/cityhash"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/cityhash/cityhash-1.1.1.tar.gz"
  sha256 "76a41e149f6de87156b9a9790c595ef7ad081c321f60780886b520aecb7e3db4"

  bottle do
    cellar :any
    sha256 "4d7f25360b715d36177c70f06f7c21f39d38b6b8aa9f8a5befe80818baa3545f" => :mojave
    sha256 "37e8244399c42c6f3bdb2fad91562607e96bc3380378d318ceecbc16ec8d52be" => :high_sierra
    sha256 "62d8d1409dfe744d4de7a1727824b06c5a80b248433c2d8bd8a4efcd444346cb" => :sierra
    sha256 "b09962ca43b3bb3321e1e57bf74a0936142ec5c94e198113ac3aa14e669e4d28" => :el_capitan
    sha256 "2b155183e2422811593d91b415ac2e90a00b7d6972f284e54b3214940250935e" => :yosemite
    sha256 "6c361a421b5f59c32c1098d4c29dd0c8f3048cf288c8880e954448926ed26184" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <stdio.h>
      #include <city.h>

      int main() {
        const char* a = "This is my test string";
        uint64_t result = CityHash64(a, sizeof(a));
        printf("result: %llx\\n", result);
        return result != 0xab7a556ed7598b04LL;
      }
    EOS
    system ENV.cxx, "-L#{lib}", "-lcityhash", "test.cpp", "-o", "test"
    system "./test"
  end
end
