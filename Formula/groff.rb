class Groff < Formula
  desc "GNU troff text-formatting system"
  homepage "https://www.gnu.org/software/groff/"
  url "https://ftp.gnu.org/gnu/groff/groff-1.22.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/groff/groff-1.22.3.tar.gz"
  sha256 "3a48a9d6c97750bfbd535feeb5be0111db6406ddb7bb79fc680809cda6d828a5"

  bottle do
    sha256 "5bdaafdace945e11059affc078fe7fea5bd367e18072c5391cfb9bb93b32bb84" => :mojave
    sha256 "fc636952c14127c45b4846e6a7fea45710514ecaf6282dc24094029393f38f10" => :high_sierra
    sha256 "bc116f66735a0b9113319e2fa8fc52172ce7e34dbfb7683f79664093ee119432" => :sierra
    sha256 "7a83070643f180e6e2644a4631a24ee908f80158e43166d7d9fabd1f60d039ca" => :el_capitan
    sha256 "55da66201119dd58fa96bbdb94a421d40fc6daba86bbc10ab6abc33763be17df" => :yosemite
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
    <<~EOS
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
