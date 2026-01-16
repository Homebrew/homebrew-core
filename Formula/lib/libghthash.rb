class Libghthash < Formula
  desc "Generic hash table for C++"
  homepage "https://github.com/SimonKagstrom/libghthash"
  url "https://github.com/SimonKagstrom/libghthash/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "e7e5f77df3e2a9152e0805f279ac048af9e572b83e60d29257cc754f8f9c22d6"
  license "LGPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "d7096c6bf880a73709d0af12108c6692688023139171cbe08cf931c9a8a51748"
    sha256 cellar: :any,                 arm64_sequoia:  "83b25e095be2d03fda04742c1c917ff6d5603d4c5ec2e6070f0e555f03e7b701"
    sha256 cellar: :any,                 arm64_sonoma:   "5339394b36965f5152703a4bc84c1303c6966114c3bd053ed9dd265951ad5b6e"
    sha256 cellar: :any,                 arm64_ventura:  "da435927873c75652094f28442c3716e305ec2407532c79f511c775452f36b35"
    sha256 cellar: :any,                 arm64_monterey: "dd42e58f241de38a3693c9fdc1098fc88caf962412c743dd67b9520a0032f021"
    sha256 cellar: :any,                 arm64_big_sur:  "3fb2c3c6419f8114001399f87e711972fcb666cbfcf1f8c5017fc69d5c7cfb4f"
    sha256 cellar: :any,                 sonoma:         "14f20c876d6f2ea724a30b0263ceec725918ed15e4fab47f8cc6b524b1404d85"
    sha256 cellar: :any,                 ventura:        "e9d123d2cb290ac32e7cf10a30132f0aa3a1e94e70c75abb54a17eb967bb5b21"
    sha256 cellar: :any,                 monterey:       "5ccf16cfdcdc676a17a295b4b48458ab91922d0fee37f15d57562084a6f6d56a"
    sha256 cellar: :any,                 big_sur:        "eb1611b48ba1ca6ba97e992f1c18972e375eb2bb2d41cab1b652fb84d11f8aa1"
    sha256 cellar: :any,                 catalina:       "746863cafe6d156513a4ba1c1a456f6d89014dad87ca825390162d8ea58a665a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "616c6f3e4acf1224a29ddea3cdf3a8092b317a197076c006555c43b23999b534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e68f5371484da5c89bbe2f40b66f8158334bfe4d436047aa521250d7ff111e6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-dependency-tracking",
           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lghthash", "-o", "test"
    system "./test"
  end
end
