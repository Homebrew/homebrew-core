class Mhash < Formula
  desc "Uniform interface to a large number of hash algorithms"
  homepage "https://mhash.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mhash/mhash/0.9.9.9/mhash-0.9.9.9.tar.gz"
  sha256 "3dcad09a63b6f1f634e64168dd398e9feb9925560f9b671ce52283a79604d13e"

  bottle do
    cellar :any
    sha256 "b4ee65a9ee33f5e19e085c477ec1634e2aa1626331eb2465484713759b264163" => :mojave
    sha256 "82f39af8037f070fafcad0280b151dc58e1b5b8c3ea1fb75f4ee372256d3ad2b" => :high_sierra
    sha256 "f630165dd7f7a0f8e5b710e0e0af5ebca6ca0edc98cd46a01b617a3e16bff7ea" => :sierra
    sha256 "8817cea2b724d7ea00fd1efb348aa8bdb5d93ca155cb9ccf8eb316f76b42941b" => :el_capitan
    sha256 "fb03873f042a16fd2db5ae2a7eb62e970927b75a9dff92decbb3fd035a2bd41f" => :yosemite
    sha256 "eb2799dca9f7c9d020e76034361c5859a4dc7e8aecaf4f1e989901b12ef4420c" => :mavericks
    sha256 "611123db41bf9d43b1937fe15451da7a0f4d2049660a98a4237618345b8d4a50" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "mhash.h"
      int main() {
        MHASH td;
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lmhash", "-o", "test"
    system "./test"
  end
end
