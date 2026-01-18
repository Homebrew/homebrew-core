class Libsigsegv < Formula
  desc "Library for handling page faults in user mode"
  homepage "https://www.gnu.org/software/libsigsegv/"
  url "https://ftpmirror.gnu.org/gnu/libsigsegv/libsigsegv-2.15.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libsigsegv/libsigsegv-2.15.tar.gz"
  sha256 "036855660225cb3817a190fc00e6764ce7836051bacb48d35e26444b8c1729d9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3255ddf74cd30522472c3eb1d068211b8d1e4ffdc337c02795052d872b206e35"
    sha256 cellar: :any,                 arm64_sequoia: "109f995641898a6ada63b7f070483a589a4f5a243a34ef44630ae25afa8191f9"
    sha256 cellar: :any,                 arm64_sonoma:  "3fab0c06f901ea4957e99d6e39992d8569278d426413546576d7bd5c843dcee0"
    sha256 cellar: :any,                 arm64_ventura: "1b56220b905ce813aae9891e7007cda1c147070662ee2f30b6cd99b14c996431"
    sha256 cellar: :any,                 sonoma:        "baa53f3c9919907d490efbdf703e7c2c8418169aa125a919151ecea253c960e1"
    sha256 cellar: :any,                 ventura:       "ef39b7c25ad4d9ba5b4c821341461328cea7b09b782acc2e0dde7e5f90340175"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c320840a4390cfe47fc07554df379d4636428b8d910e411b188db01c2c98d5a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c64896be0e57b66fdc9086d93835beaf01f269826d3beaae2d6e4ec14ae2eb3"
  end

  head do
    url "https://git.savannah.gnu.org/git/libsigsegv.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

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
