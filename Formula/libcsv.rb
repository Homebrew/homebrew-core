class Libcsv < Formula
  desc "CSV library in ANSI C89"
  homepage "https://sourceforge.net/projects/libcsv/"
  url "https://downloads.sourceforge.net/project/libcsv/libcsv/libcsv-3.0.3/libcsv-3.0.3.tar.gz"
  sha256 "d9c0431cb803ceb9896ce74f683e6e5a0954e96ae1d9e4028d6e0f967bebd7e4"

  bottle do
    cellar :any
    rebuild 2
    sha256 "ad3c84168c138aef88134f7666f870dcb17f8b779b5e5b54417515f7c9b740af" => :mojave
    sha256 "6946a6ff37a03f75d464cdc1229eb72251ae6b5d2726a658a016e39e862f0e33" => :high_sierra
    sha256 "6d89efd634be6551134f099e458225325d76d69f55ba37676a3ccf7bea6c4e59" => :sierra
    sha256 "3f69bb369fafd5c207f1c8ea500dc1e725e8e7dfe005215ff14b61fc25ac28e6" => :el_capitan
    sha256 "ace67ec808ae6963525164b700ace39c8552f0c68364415401fea532f3ea2fe2" => :yosemite
    sha256 "7c32b16f3528f615214dcca0633995ec01a70ff4db8badd09cbcc3a884fe64fc" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <csv.h>
      int main(void) {
        struct csv_parser p;
        csv_init(&p, CSV_STRICT);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcsv", "-o", "test"
    system "./test"
  end
end
