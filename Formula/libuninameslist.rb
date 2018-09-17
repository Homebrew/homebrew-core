class Libuninameslist < Formula
  desc "Library of Unicode names and annotation data"
  homepage "https://github.com/fontforge/libuninameslist"
  url "https://github.com/fontforge/libuninameslist/releases/download/20180701/libuninameslist-dist-20180701.tar.gz"
  sha256 "8aed97d0bc872d893d8bf642a14e49958b0613136e1bfe2a415c69599c803c90"

  bottle do
    cellar :any
    sha256 "a71c341da75240eb39ce630c7420a9ab0aeb0bd14a550e6c881137f442ce837f" => :mojave
    sha256 "6ddb46e2ce0578c33caff01908983536fcf5b4d15e8f71d2df98d69c63846a33" => :high_sierra
    sha256 "99824aa3d96ac74329faff3efb8be400ab2041f8a5f1111a81b23ee342711e8e" => :sierra
    sha256 "6e612d55283ea85566bbbade489cab1b99d566816ee35d9e412a1cf23931587e" => :el_capitan
  end

  head do
    url "https://github.com/fontforge/libuninameslist.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    if build.head?
      system "autoreconf", "-i"
      system "automake"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <uninameslist.h>

      int main() {
        (void)uniNamesList_blockCount();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-luninameslist", "-o", "test"
    system "./test"
  end
end
