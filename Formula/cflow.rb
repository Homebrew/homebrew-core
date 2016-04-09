class Cflow < Formula
  desc "Generate call graphs from C code"
  homepage "https://www.gnu.org/software/cflow/"
  url "http://ftpmirror.gnu.org/cflow/cflow-1.4.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/cflow/cflow-1.4.tar.bz2"
  sha256 "037e39d6048ea91c68a5f3a561e10f22fd085d1f7641643e19c831a94ec26bca"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3540e10810d3ebde1e83ff1afef0921c185539dcff2d6f9826699c6c41db922" => :el_capitan
    sha256 "7a6dd05ed5c0e5f976ff5654070b72ccbf60e55c2cd0a54b493576c5971bacaa" => :yosemite
    sha256 "6eda420db0dc8040e9607efe65e6c508410759a2d04afa7f5420154b38a14058" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--infodir=#{info}"
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
