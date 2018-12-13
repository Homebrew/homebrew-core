class Groff < Formula
  desc "GNU troff text-formatting system"
  homepage "https://www.gnu.org/software/groff/"
  url "https://ftp.gnu.org/gnu/groff/groff-1.22.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/groff/groff-1.22.3.tar.gz"
  sha256 "3a48a9d6c97750bfbd535feeb5be0111db6406ddb7bb79fc680809cda6d828a5"

  bottle do
    rebuild 1
    sha256 "117230db80bea766e9bdd3f0af02911d824ac333a14c466762ef475dc7ffc5bb" => :mojave
    sha256 "cbcd60c91851bfeb7d32d292bc2f1838ee130b1e9b87c4bac535142b7c8dc4de" => :high_sierra
    sha256 "39945f37f43ad6ad93d87469847dff4d75f720a9209c0e4c5596c61eb611b6ae" => :sierra
  end

  patch :DATA # fix parallel build, https://savannah.gnu.org/bugs/index.php?43581

  def install
    system "./configure", "--prefix=#{prefix}", "--without-x"
    system "make" # Separate steps required
    system "make", "install"
  end

  test do
    assert_match "homebrew\n",
      pipe_output("#{bin}/groff -a", "homebrew\n")
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index bc156ce..70c6f85 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -896,6 +896,8 @@ $(GNULIBDIRS): FORCE
	  $(MAKE) ACLOCAL=: AUTOCONF=: AUTOHEADER=: AUTOMAKE=: $(do) ;; \
	esac

+$(SHPROGDIRS): $(PROGDEPDIRS)
+
 $(OTHERDIRS): $(PROGDEPDIRS) $(CCPROGDIRS) $(CPROGDIRS) $(SHPROGDIRS)

 $(INCDIRS) $(PROGDEPDIRS) $(SHPROGDIRS) $(OTHERDIRS): FORCE
