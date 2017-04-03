class Groff < Formula
  desc "GNU troff text-formatting system"
  homepage "https://www.gnu.org/software/groff/"
  url "https://ftpmirror.gnu.org/groff/groff-1.22.3.tar.gz"
  mirror "https://ftp.gnu.org/gnu/groff/groff-1.22.3.tar.gz"
  sha256 "3a48a9d6c97750bfbd535feeb5be0111db6406ddb7bb79fc680809cda6d828a5"

  bottle do
    sha256 "c606ada7a9a36347de1da1b8afb985e366430a7829b4521659a735fcfa287242" => :el_capitan
    sha256 "ebe38751269dc365aaf656c980455b45292288b5b8ecaa709af1c9f073b8019c" => :yosemite
    sha256 "f93c76d63a4b2aea4be979cc3331e9a617fcaa35418979c6f2bdee1817813b2f" => :mavericks
  end

  option "with-gropdf", "Enable PDF output support"
  option "with-grohtml", "Enable HTML output support (implies --with-gropdf)"
  option "with-gpresent", "Install macros for the presentations document format"

  if build.with? "grohtml"
    depends_on "ghostscript"
    depends_on "netpbm"
    depends_on "psutils"
  elsif build.with? "gropdf"
    depends_on "ghostscript"
  end

  resource "gpresent" do
    url "https://staff.fnwi.uva.nl/b.diertens/useful/gpresent/gpresent-2.3.tar.gz"
    sha256 "a76b9b939f8107d53d7a3c9c1f403a3af23868c1e6b2e609ef70b30d12d70c51"
  end

  patch :DATA # fix parallel build, https://savannah.gnu.org/bugs/index.php?43581

  def install
    system "./configure", "--prefix=#{prefix}", "--without-x"
    system "make" # Separate steps required
    system "make", "install"

    if build.with? "gpresent"
      resource("gpresent").stage do
        (pkgshare/"site-tmac").install Dir["*.tmac"]
        (pkgshare/"examples").install Dir["*.rof", "*.pdf"]
        man7.install Dir["*.7"]
        man1.install Dir["*.1"]
        bin.install "presentps"
      end
    end
  end

  def caveats
    <<-EOS.undent
    Attempting to use PDF or HTML output support without using --with-gropdf or
    --with-grohtml may result in errors.
    EOS
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
