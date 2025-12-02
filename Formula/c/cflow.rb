class Cflow < Formula
  desc "Generate call graphs from C code"
  homepage "https://www.gnu.org/software/cflow/"
  url "https://ftpmirror.gnu.org/gnu/cflow/cflow-1.8.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/cflow/cflow-1.8.tar.bz2"
  sha256 "8321627b55b6c7877f6a43fcc6f9f846a94b1476a081a035465f7a78d3499ab8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "7677a8663bf8dbc2178670bc1db544f12fbb8c87d644c3863457e40ff6a6ea84"
    sha256 arm64_sequoia: "6d482293b619d39dba15d8a1956ab25b4434ae53fe93ac269e9ffd2af7f33cdd"
    sha256 arm64_sonoma:  "e2f7275d45e7808088c8912fb70dca9f5f1bc98e9375ef67fc9ecca3b5f6bba9"
    sha256 arm64_ventura: "723f38543a7356fd374a9753005605a93d705b6c9723c8ef40ae31176b54e05d"
    sha256 sonoma:        "8347d85dfa5f30c5e3697842e7130d6ef3b712eb250eb945d312a97040020581"
    sha256 ventura:       "18555eed054a739c2bf0a562deebc509ab53c96964937b3cbc223d9a1617b2ee"
    sha256 arm64_linux:   "dbcdfdec9d78e04d94d2ed339ead98ffd3d1c45ff101d5f06d546582bcbc19c0"
    sha256 x86_64_linux:  "fc739d521aacfc482f787c8843057c122317b3a91434bafd55cf94f182ef4f93"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-lispdir=#{elisp}"

    # Replace C++11 attribute syntax with GCC-style attribute for Clang compatibility
    if OS.mac? && DevelopmentTools.clang_build_version >= 1500
      inreplace "config.h", /\[\[__maybe_unused__\]\]/, "__attribute__((__unused__))"
    end

    system "make", "install"
  end

  test do
    (testpath/"whoami.c").write <<~C
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
    C

    assert_match "getpwuid()", shell_output("#{bin}/cflow --main who_am_i #{testpath}/whoami.c")
  end
end
