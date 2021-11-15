class Libsigsegv < Formula
  desc "Library for handling page faults in user mode"
  homepage "https://www.gnu.org/software/libsigsegv/"
  url "https://ftp.gnu.org/gnu/libsigsegv/libsigsegv-2.13.tar.gz"
  mirror "https://ftpmirror.gnu.org/libsigsegv/libsigsegv-2.13.tar.gz"
  sha256 "be78ee4176b05f7c75ff03298d84874db90f4b6c9d5503f0da1226b3a3c48119"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e131f8e70ae22c236cf1c3061de2710671b6be977f9c0640c3e3226da0cd395b"
    sha256 cellar: :any,                 arm64_big_sur:  "709a1a801698a0e0862be0f71d9b15ed8af9b6777956ae2caf0795d418956ce4"
    sha256 cellar: :any,                 monterey:       "e4d9698e740e043b010752b577c5a0db82db2e26645449ca45cef2906bc01611"
    sha256 cellar: :any,                 big_sur:        "9bd929ab1b6a2c35bdde0306a2a4c30498a47659ae0877bc89a7b74f67d93425"
    sha256 cellar: :any,                 catalina:       "0d7f731afff70661df049267de9fe2c34b74d3918a7a7695fbfd1deef664aa68"
    sha256 cellar: :any,                 mojave:         "95525c7e620743555e44175496c21c57a8cc39b8ca2670bf0fd690cc42a2977c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61ea7eb4168f98ae1177e9dd5def5bd9883724351d41f805bf996f5482904b80"
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
