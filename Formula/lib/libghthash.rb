class Libghthash < Formula
  desc "Generic hash table for C++"
  homepage "https://web.archive.org/web/20170824230514/www.bth.se/people/ska/sim_home/libghthash.html"
  url "https://web.archive.org/web/20170824230514/www.bth.se/people/ska/sim_home/filer/libghthash-0.6.2.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/libghthash-0.6.2.tar.gz"
  sha256 "d1ccbb81f4c8afd7008f56ecb874f5cf497de480f49ee06929b4303d5852a7dd"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "da435927873c75652094f28442c3716e305ec2407532c79f511c775452f36b35"
    sha256 cellar: :any,                 arm64_monterey: "dd42e58f241de38a3693c9fdc1098fc88caf962412c743dd67b9520a0032f021"
    sha256 cellar: :any,                 arm64_big_sur:  "3fb2c3c6419f8114001399f87e711972fcb666cbfcf1f8c5017fc69d5c7cfb4f"
    sha256 cellar: :any,                 ventura:        "e9d123d2cb290ac32e7cf10a30132f0aa3a1e94e70c75abb54a17eb967bb5b21"
    sha256 cellar: :any,                 monterey:       "5ccf16cfdcdc676a17a295b4b48458ab91922d0fee37f15d57562084a6f6d56a"
    sha256 cellar: :any,                 big_sur:        "eb1611b48ba1ca6ba97e992f1c18972e375eb2bb2d41cab1b652fb84d11f8aa1"
    sha256 cellar: :any,                 catalina:       "746863cafe6d156513a4ba1c1a456f6d89014dad87ca825390162d8ea58a665a"
    sha256 cellar: :any,                 mojave:         "b6092f29d1b937b03313780a88f91f224cbbc73a564fca0a0810d036ea20b63d"
    sha256 cellar: :any,                 high_sierra:    "f9f17a73ef48e31f809d884ce1a419fe4568b167bb962cdf07c4197688572d59"
    sha256 cellar: :any,                 sierra:         "730eb3945e001efa5ebfc84452c94b69237f3cdf830ef5c58cef8854ed4cd3d6"
    sha256 cellar: :any,                 el_capitan:     "e889f34ca4f1978869eff48334f1f55248628fbc586abdeb151fe017479d220e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e68f5371484da5c89bbe2f40b66f8158334bfe4d436047aa521250d7ff111e6"
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
