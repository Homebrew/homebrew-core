class Libsigsegv < Formula
  desc "Library for handling page faults in user mode"
  homepage "https://www.gnu.org/software/libsigsegv/"
  url "https://ftpmirror.gnu.org/libsigsegv/libsigsegv-2.16.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libsigsegv/libsigsegv-2.16.tar.gz"
  sha256 "f8b2fac06c091fc29d6474733d118dc163ed7cd6be4783240d31ad7af11efa30"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0396c86719dec7735598c913fbc3123f1dc7fd0a7cd29e1657e1707f7d84e0aa"
    sha256 cellar: :any, arm64_tahoe:       "c8c31bf94e9848ab41c559f87d2900e9d8cbb436748224b24328e80cae20f3d5"
    sha256 cellar: :any, arm64_sequoia:     "b6f6b65a6ac29eaf4858763caf5f6453a0c795380393ddc842343f5766351159"
    sha256 cellar: :any, arm64_linux:       "270d92daf11deecb8c151507938252b0714e87fee71d939156aed8660d531285"
    sha256 cellar: :any, x86_64_linux:      "4d2b76a7fb6a5d4ae95de83fabdee92f0453e873a4cc9e93721aad8b288dea70"
  end

  head do
    url "https://git.savannah.gnu.org/git/libsigsegv.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  deny_network_access!

  def install
    system "./gitsub.sh", "pull" if build.head?
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    # Sourced from tests/efault1.c in tarball.
    (testpath/"test.c").write <<~C
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
    C

    system ENV.cc, "test.c", "-L#{lib}", "-lsigsegv", "-o", "test"
    assert_match "Test passed", shell_output("./test")
  end
end
