class Cflow < Formula
  desc "Generate call graphs from C code"
  homepage "https://www.gnu.org/software/cflow/"
  url "https://ftp.gnu.org/gnu/cflow/cflow-1.6.tar.bz2"
  mirror "https://ftpmirror.gnu.org/cflow/cflow-1.6.tar.bz2"
  sha256 "34487b4116e9b7ecde142b24480ce036887921ed5defb2958068bb069c1fedd7"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8b7329845d3c42a17efc7af96025a1a2839ae129afd7126e977d0a245853f45" => :catalina
    sha256 "a96f9cf3cb35851c27ed602f6a05489da2d64e75ab6daccecc3e23156d9fe968" => :mojave
    sha256 "50a816924cb91e1c4055923285ea3ceb0d815b4641477906ae5f6abdae337d52" => :high_sierra
    sha256 "5e88f5310c34255947032f24227cf779aa8a42fe595f585605e814f001f4a151" => :sierra
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

    assert_match /getpwuid()/, shell_output("#{bin}/cflow --main who_am_i #{testpath}/whoami.c")
  end
end
