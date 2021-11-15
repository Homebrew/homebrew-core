class Cflow < Formula
  desc "Generate call graphs from C code"
  homepage "https://www.gnu.org/software/cflow/"
  url "https://ftp.gnu.org/gnu/cflow/cflow-1.6.tar.bz2"
  mirror "https://ftpmirror.gnu.org/cflow/cflow-1.6.tar.bz2"
  sha256 "34487b4116e9b7ecde142b24480ce036887921ed5defb2958068bb069c1fedd7"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea9bd9605326d36b0f744b380a235e9f34c2dc50fc5e771e95d3aaf1abfdbf36"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0b017a7e277a9ba4d337df8318c0e9154c235329a846151d8be03bdef75c58e"
    sha256 cellar: :any_skip_relocation, monterey:       "32312d230803f862d7fb53cb2a2e32892351a7ff530a94e3a3756494eb81946d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b131f52fdaf1658378dbcc134be8c2d713e2e1d66002df05ef8d1ccfcac132e8"
    sha256 cellar: :any_skip_relocation, catalina:       "a8b7329845d3c42a17efc7af96025a1a2839ae129afd7126e977d0a245853f45"
    sha256 cellar: :any_skip_relocation, mojave:         "a96f9cf3cb35851c27ed602f6a05489da2d64e75ab6daccecc3e23156d9fe968"
    sha256 cellar: :any_skip_relocation, high_sierra:    "50a816924cb91e1c4055923285ea3ceb0d815b4641477906ae5f6abdae337d52"
    sha256 cellar: :any_skip_relocation, sierra:         "5e88f5310c34255947032f24227cf779aa8a42fe595f585605e814f001f4a151"
    sha256                               x86_64_linux:   "06ad443c55fb5979f0986088dcf96b22b739d7c12d51d593c063bc70018de5d9"
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
