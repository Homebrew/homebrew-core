class Popt < Formula
  desc "Library like getopt(3) with a number of enhancements"
  homepage "https://github.com/rpm-software-management/popt"
  url "http://ftp.rpm.org/popt/releases/popt-1.x/popt-1.18.tar.gz"
  sha256 "5159bc03a20b28ce363aa96765f37df99ea4d8850b1ece17d1e6ad5c24fdc5d1"

  bottle do
    cellar :any
    rebuild 3
    sha256 "26d76db3d80802bbc9c93b935bea569d8640cb081d75ff58e240cc90cb0bdb5a" => :catalina
    sha256 "62d43c019e6968bc603f4e5ae323ca957d50bccb0d1e797eba6d411c8f3941e4" => :mojave
    sha256 "bc17d5c36c45dfba60d51599cc910f0533f7a600d983e433000c445d261a204f" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <popt.h>

      int main(int argc, char *argv[]) {
          int optiona=-1, optionb=-1, optionc=-1, flag1=0, flag2=0;

          poptContext pc;
          struct poptOption po[] = {
              {"optiona", 'a', POPT_ARG_INT, &optiona, 11001, "descrip1", "argDescrip1"},
              {"optionb", 'b', POPT_ARG_INT, &optionb, 11002, "descrip2", "argDescrip2"},
              {"optionc", 'c', POPT_ARG_INT, &optionc, 11003, "descrip3", "argDescrip3"},
              {"flag1", 'f', POPT_ARG_NONE, &flag1, 11004, "descrip4", "argDescrip4"},
              {"flag2", 'g', POPT_ARG_NONE, &flag2, 11005, "descrip5", "argDescrip5"},
              POPT_AUTOHELP
              {NULL}
          };

          pc = poptGetContext(NULL, argc, (const char **)argv, po, 0);
          poptSetOtherOptionHelp(pc, "[ARG...]");
          if (argc < 2) {
              poptPrintUsage(pc, stderr, 0);
              exit(1);
          }

          int val;
          while ((val = poptGetNextOpt(pc)) >= 0);

          if (val != -1) {
              switch(val) {
              case POPT_ERROR_NOARG:
                  printf("Argument missing for an option\\n");
                  exit(1);
              case POPT_ERROR_BADOPT:
                  printf("Option's argument could not be parsed\\n");
                  exit(1);
              case POPT_ERROR_BADNUMBER:
              case POPT_ERROR_OVERFLOW:
                  printf("Option could not be converted to number\\n");
                  exit(1);
              default:
                  printf("Unknown error in option processing\\n");
                  exit(1);
              }
          }

          printf("%d\\n%d\\n%d\\n%d\\n%d\\n", optiona, optionb, optionc, flag1, flag2);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpopt", "-o", "test"
    assert_equal "123\n456\n789\n1\n0\n", shell_output("./test -a 123 -b 456 -c 789 -f")
    assert_equal "987\n654\n321\n0\n1\n", shell_output("./test --optiona=987 --optionb=654 --optionc=321 --flag2")
  end
end
