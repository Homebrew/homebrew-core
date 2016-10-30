class Cflow < Formula
  desc "Generate call graphs from C code"
  homepage "https://www.gnu.org/software/cflow/"
  url "https://ftpmirror.gnu.org/cflow/cflow-1.5.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/cflow/cflow-1.5.tar.bz2"
  sha256 "6fe40a106a9ffd6a5489938b939d4301c04fa28a09596294b4f787abca1c037b"

  bottle do
    cellar :any_skip_relocation
    sha256 "40efaa5c5298d6aa3ca2bce884ede21d21cb59df94eee0bc121a588dcb58257b" => :sierra
    sha256 "4bde642d869a9ea7347ad91bdb87a0de3c93f3766e8b74bb6e74a763278724c3" => :el_capitan
    sha256 "ae1fcbcfbf28417dfcc4836f32446ece545e9fceee61f34617d6364a2dd106e0" => :yosemite
    sha256 "b50f226680f8b0e3acaea2e09781cd6d7b03bdf1191fe338658d9aacef448a9f" => :mavericks
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
    (testpath/"whoami.c").write <<-EOS.undent
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

    assert_match /getpwuid()/, shell_output("#{bin}/cflow --main who_am_i #{testpath}/whoami.c")
  end
end
