class Mimetic < Formula
  desc "C++ MIME library"
  homepage "http://www.codesink.org/mimetic_mime_library.html"
  url "http://www.codesink.org/download/mimetic-0.9.8.tar.gz"
  sha256 "3a07d68d125f5e132949b078c7275d5eb0078dd649079bd510dd12b969096700"

  bottle do
    cellar :any
    sha256 "8ed48d215ceee3cfd34faef45e460ca022e690b7bc787fdb91d9e84e1e71863b" => :sierra
    sha256 "d836b7b260b8705617f0a7e49ad674c0e2428810fa6e8228913253e4e4e2e873" => :el_capitan
    sha256 "0d3f1d86b2c73efdfad1e3c65e1cb9e0257c75d24cc46133730c2deb0b710319" => :yosemite
    sha256 "bc076f799788cbb59f7c822d77a5693f7fbd1c11eb5cc3a6388bf11921b2e749" => :mavericks
  end

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
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lmimetic", "-o", "test"
    system "./test"
  end
end
