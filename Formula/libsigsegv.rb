class Libsigsegv < Formula
  desc "Library for handling page faults in user mode"
  homepage "https://www.gnu.org/software/libsigsegv/"
  url "https://ftp.gnu.org/gnu/libsigsegv/libsigsegv-2.11.tar.gz"
  mirror "https://ftpmirror.gnu.org/libsigsegv/libsigsegv-2.11.tar.gz"
  sha256 "dd7c2eb2ef6c47189406d562c1dc0f96f2fc808036834d596075d58377e37a18"

  bottle do
    cellar :any
    sha256 "ab8908ac5dd0796d8f3f4452d057ac18cc335f909f13ad866f8c721f043d3ce3" => :sierra
    sha256 "ded2b14d1110f67dcc52f79525e3b37ba85943cc487b14e4e330f28963c8ebf2" => :el_capitan
    sha256 "71448886166937e22df81d47a2836470fed0ddc4349cac1dec7f668c9048e398" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    # Sourced from tests/efault1.c in tarball.
    (testpath/"test.c").write <<-EOS.undent
      #include "sigsegv.h"

      #include <errno.h>
      #include <fcntl.h>
      #include <stdio.h>
      #include <stdlib.h>
      #include <unistd.h>

      const char *null_pointer = NULL;
      static int
      handler (void *fault_address, int serious)
      {
        abort ();
      }

      int
      main ()
      {
        if (open (null_pointer, O_RDONLY) != -1 || errno != EFAULT)
          {
            fprintf (stderr, "EFAULT not detected alone");
            exit (1);
          }

        if (sigsegv_install_handler (&handler) < 0)
          exit (2);

        if (open (null_pointer, O_RDONLY) != -1 || errno != EFAULT)
          {
            fprintf (stderr, "EFAULT not detected with handler");
            exit (1);
          }

        printf ("Test passed");
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-lsigsegv", "-o", "test"
    assert_match /Test passed/, shell_output("./test")
  end
end
