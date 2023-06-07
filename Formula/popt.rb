class Popt < Formula
  desc "Library like getopt(3) with a number of enhancements"
  homepage "https://github.com/rpm-software-management/popt"
  url "http://ftp.rpm.org/popt/releases/popt-1.x/popt-1.19.tar.gz"
  mirror "https://ftp.osuosl.org/pub/rpm/popt/releases/popt-1.x/popt-1.19.tar.gz"
  sha256 "c25a4838fc8e4c1c8aacb8bd620edb3084a3d63bf8987fdad3ca2758c63240f9"
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
    sha256 cellar: :any,                 arm64_ventura:  "9cabf84985466e8531cff42433a8df6b16668222537544b0295dab0cef292e53"
    sha256 cellar: :any,                 arm64_monterey: "1154aeb3aedee17c3dddb8f7896f4b5f6b4d7d9dc5334fd1011fb96768788e9c"
    sha256 cellar: :any,                 arm64_big_sur:  "36a746fdc0e913f77421aebbde75099112fb452beeca9d5420cd1d3907802fa6"
    sha256 cellar: :any,                 ventura:        "4826c003aae6f5407fc0f7e9db8ae2a8e8aad55fab65e1556d7a8db300af8110"
    sha256 cellar: :any,                 monterey:       "7d6cc173811a3aa97adae35f9c0a759acec73e0bc2c948fdb012f2691b4aef3d"
    sha256 cellar: :any,                 big_sur:        "92d031d6010ce339beb5d179471ac14b76e887cba2d8cd7699c41aa1d76bcee5"
    sha256 cellar: :any,                 catalina:       "bab861fc16b94cf46a1a438503ea5e7a602a2c750be14706210e83f63f4abaaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaf6aef4cf756e5ad7d75b04d51efb181e673be05bbc40053123b7e8f975db76"
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
