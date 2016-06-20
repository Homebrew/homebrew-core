class Mimetic < Formula
  desc "C++ MIME library"
  homepage "http://www.codesink.org/mimetic_mime_library.html"
  url "http://www.codesink.org/download/mimetic-0.9.8.tar.gz"
  sha256 "3a07d68d125f5e132949b078c7275d5eb0078dd649079bd510dd12b969096700"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include <mimetic/mimetic.h>

      using namespace std;
      using namespace mimetic;

      int main()
      {
            MimeEntity me;
            me.header().from("me <me@domain.com>");
            me.header().to("you <you@domain.com>");
            me.header().subject("my first mimetic msg");
            me.body().assign("hello there!");
            cout << me << endl;
            return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L/usr/local/lib", "-lmimetic", "-o", "test"
    system "./test"
  end
end
