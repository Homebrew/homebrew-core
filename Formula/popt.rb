class Popt < Formula
  desc "Library like getopt(3) with a number of enhancements"
  homepage "https://github.com/rpm-software-management/popt"
  url "http://ftp.rpm.org/popt/releases/popt-1.x/popt-1.18.tar.gz"
  mirror "https://ftp.osuosl.org/pub/rpm/popt/releases/popt-1.x/popt-1.18.tar.gz"
  sha256 "5159bc03a20b28ce363aa96765f37df99ea4d8850b1ece17d1e6ad5c24fdc5d1"
  license "MIT"

  # The stable archive is found at https://ftp.osuosl.org/pub/rpm/popt/releases/popt-1.x/
  # but it's unclear whether this would be a reliable check in the long term.
  # We're simply checking the Git repository tags for the moment, as we
  # shouldn't encounter problems with this method.
  livecheck do
    url :homepage
    regex(/^(?:popt[._-])?v?(\d+(?:[._]\d+)+)(?:[._-]release)?$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "70cc83818b69346e152c8d0fa10eafff979b0da3e17355d18bb63ee700da5415"
    sha256 cellar: :any,                 arm64_big_sur:  "3ebf58493631c204386f60a189af7cc4127240644a0ce4713dd4af4374e45823"
    sha256 cellar: :any,                 monterey:       "063b3f00f194a65246b589e74daf0ce30e0797068fea4a93062dc0b251f4d73c"
    sha256 cellar: :any,                 big_sur:        "460da044609e1821375dd248e5bb1a317a0f5e3f0431c4ab19532b2cfa6d7e7a"
    sha256 cellar: :any,                 catalina:       "a5cbf26e1779c73865c7785adc163117465d321338aa6970dd4980cff4a2ec91"
    sha256 cellar: :any,                 mojave:         "5d602602f195811a3ea8c29ce4540cca6e1f36890a08b5a262facf3f74a85cf1"
    sha256 cellar: :any,                 high_sierra:    "554ba881a515b18e53d1abd7f67a544af42d811ea14283e75b13ae5fc2056024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b1fca748f705b965b222943f75fd97cdef1bfb3e98b478b49745cf50a89f7fa"
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
