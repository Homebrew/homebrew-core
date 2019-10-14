class Libghthash < Formula
  desc "Generic hash table for C++"
  homepage "https://web.archive.org/web/20170824230514/www.bth.se/people/ska/sim_home/libghthash.html"
  url "https://web.archive.org/web/20170824230514/www.bth.se/people/ska/sim_home/filer/libghthash-0.6.2.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/libghthash-0.6.2.tar.gz"
  sha256 "d1ccbb81f4c8afd7008f56ecb874f5cf497de480f49ee06929b4303d5852a7dd"

  bottle do
    cellar :any
    sha256 "746863cafe6d156513a4ba1c1a456f6d89014dad87ca825390162d8ea58a665a" => :catalina
    sha256 "b6092f29d1b937b03313780a88f91f224cbbc73a564fca0a0810d036ea20b63d" => :mojave
    sha256 "f9f17a73ef48e31f809d884ce1a419fe4568b167bb962cdf07c4197688572d59" => :high_sierra
    sha256 "730eb3945e001efa5ebfc84452c94b69237f3cdf830ef5c58cef8854ed4cd3d6" => :sierra
    sha256 "e889f34ca4f1978869eff48334f1f55248628fbc586abdeb151fe017479d220e" => :el_capitan
    sha256 "0487e2e14b14ae288428c474fe9ce3e9baf814d4d73de8b0113ca9cc502ffd63" => :yosemite
    sha256 "207d07d59447e098c1987286324866ef8b26e0c4c191e4c1c0268ba8d95c5fac" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-dependency-tracking",
           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <string.h>
      #include <stdio.h>
      #include <stdlib.h>
      #include <ght_hash_table.h>

      int main(int argc, char *argv[])
      {
        ght_hash_table_t *p_table;
        int *p_data;
        int *p_he;
        int result;

        p_table = ght_create(128);

        if ( !(p_data = (int*)malloc(sizeof(int))) ) {
          return 1;
        }

        *p_data = 15;

        ght_insert(p_table,
             p_data,
             sizeof(char)*strlen("blabla"), "blabla");

        if ( (p_he = ght_get(p_table,
                 sizeof(char)*strlen("blabla"), "blabla")) ) {
          result = 0;
        } else {
          result = 1;
        }
        ght_finalize(p_table);

        return result;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lghthash", "-o", "test"
    system "./test"
  end
end
