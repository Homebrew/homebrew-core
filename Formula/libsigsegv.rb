class Libsigsegv < Formula
  desc "Library for handling page faults in user mode"
  homepage "https://www.gnu.org/software/libsigsegv/"
  url "https://ftp.gnu.org/gnu/libsigsegv/libsigsegv-2.14.tar.gz"
  mirror "https://ftpmirror.gnu.org/libsigsegv/libsigsegv-2.14.tar.gz"
  sha256 "cdac3941803364cf81a908499beb79c200ead60b6b5b40cad124fd1e06caa295"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "22818cb45d09dd84f4fc68ecf1eee1484cb9a98b75fa72b89913206cf46bf19c"
    sha256 cellar: :any,                 arm64_monterey: "e8cae8734eafabb8c3bcfeba2449b1d6e309cea6ca0647ca7bdf62aca7e331db"
    sha256 cellar: :any,                 arm64_big_sur:  "f37ac4bf1b939f0703029b5143fca0dc8c77ff77f2b860800a5e0028e5fdfea8"
    sha256 cellar: :any,                 ventura:        "930a0d57f321ebb101bd7a62baff95295f08e4dad421435226877f2e0d58fda2"
    sha256 cellar: :any,                 monterey:       "3ceaebb4bf32ec972aa786360dd55fc115fb2890d16da6b2ddaa9ff199160e2c"
    sha256 cellar: :any,                 big_sur:        "6cefa3529425fcbd306c53d975bc0a727b34d8a3c636c664a1785f67202b2377"
    sha256 cellar: :any,                 catalina:       "585d16ba5f3b6b2136704ff16e58c620ee2aac3b1f7f9eb15b883efecb1ba6b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a221904699cd8cefa4d70e72f59bab5282065bc0739428286278898a147b571d"
  end

  head do
    url "https://git.savannah.gnu.org/git/libsigsegv.git"

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
    (testpath/"test.c").write <<~EOS
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

    system ENV.cc, "test.c", "-L#{lib}", "-lsigsegv", "-o", "test"
    assert_match "Test passed", shell_output("./test")
  end
end
