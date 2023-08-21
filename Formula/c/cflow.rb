class Cflow < Formula
  desc "Generate call graphs from C code"
  homepage "https://www.gnu.org/software/cflow/"
  url "https://ftp.gnu.org/gnu/cflow/cflow-1.7.tar.bz2"
  mirror "https://ftpmirror.gnu.org/cflow/cflow-1.7.tar.bz2"
  sha256 "d01146caf9001e266133417c2a8258a64b5fc16fcb082a14f6528204d0c97086"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b089cc4f286019f77084983af011c3776db86c9abc400e6b9d3415667809bea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "775aa08b6d73ae6aa6eaeef7e1b187acc8b78daf87c7be6771914213d3907b4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c243b38883f723c09ea4ebadc5cca19ede2f3210fd75379f4636fa7320fb0e0e"
    sha256 cellar: :any_skip_relocation, ventura:        "b684918ee8c5640d80e51cfce6f9b7c5dcf787f573350197a62ab877fbd92005"
    sha256 cellar: :any_skip_relocation, monterey:       "3631370161b2fe088572eb63e1653c9d591184870cbf5e6ec31187f919082cd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca4cbcfa33c53ff166dced09c73683076a112b6053ae4667abf3f97fd0aaf1be"
    sha256 cellar: :any_skip_relocation, catalina:       "aa461817268ac09391a88903ab13a8a13852c943a4d38dfe5342c202f1daf5d6"
    sha256                               x86_64_linux:   "62e41fe118da0de3ee5bbf3a85273d53aec1ada3b389f2e4b7876f4aa9f9ee0a"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-lispdir=#{elisp}"
    system "make", "install"
  end

  test do
    (testpath/"whoami.c").write <<~EOS
      #include <pwd.h>
      #include <sys/types.h>
      #include <stdio.h>
      #include <stdlib.h>

      int
      who_am_i (void)
      {
        struct passwd *pw;
        char *user = NULL;

        pw = getpwuid (geteuid ());
        if (pw)
          user = pw->pw_name;
        else if ((user = getenv ("USER")) == NULL)
          {
            fprintf (stderr, "I don't know!\n");
            return 1;
          }
        printf ("%s\n", user);
        return 0;
      }

      int
      main (int argc, char **argv)
      {
        if (argc > 1)
          {
            fprintf (stderr, "usage: whoami\n");
            return 1;
          }
        return who_am_i ();
      }
    EOS

    assert_match "getpwuid()", shell_output("#{bin}/cflow --main who_am_i #{testpath}/whoami.c")
  end
end
