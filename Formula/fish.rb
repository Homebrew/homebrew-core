class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"

  stable do
    url "https://fishshell.com/files/2.3.1/fish-2.3.1.tar.gz"
    mirror "https://github.com/fish-shell/fish-shell/releases/download/2.3.1/fish-2.3.1.tar.gz"
    sha256 "328acad35d131c94118c1e187ff3689300ba757c4469c8cc1eaa994789b98664"

    # Skip extra dirs creation during install phase patch for current stable. To be removed on the next fish release.
    # As discussed in https://github.com/Homebrew/homebrew-core/pull/2813
    # Use part of https://github.com/fish-shell/fish-shell/commit/9abbc5f upstream commit and patch the makefile.
    patch :DATA
  end

  bottle do
    sha256 "99462c8b9fc844882b8877f2b016823ce7c9e54dd89d532e13ce9e3af90558d4" => :el_capitan
    sha256 "30254c4c5bd3f2c6df4da5f805d8023f867b3ac0b5e3ed6557d864db102ff6f7" => :yosemite
    sha256 "c91612a4f4e6e99bb81a0e699adce007c48a175e73dde5af239ae7ee41f3af90" => :mavericks
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "doxygen" => :build
  end

  depends_on "pcre2"

  def install
    system "autoconf" if build.head? || build.devel?

    # In Homebrew's 'superenv' sed's path will be incompatible, so
    # the correct path is passed into configure here.
    args = %W[
      --prefix=#{prefix}
      --with-extra-functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d
      --with-extra-completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d
      --with-extra-confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d
      SED=/usr/bin/sed
    ]
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    You will need to add:
      #{HOMEBREW_PREFIX}/bin/fish
    to /etc/shells.

    Then run:
      chsh -s #{HOMEBREW_PREFIX}/bin/fish
    to make fish your default shell.
    EOS
  end

  def post_install
    (pkgshare/"vendor_functions.d").mkpath
    (pkgshare/"vendor_completions.d").mkpath
    (pkgshare/"vendor_conf.d").mkpath
  end

  test do
    system "#{bin}/fish", "-c", "echo"
  end
end

__END__
As discussed in https://github.com/Homebrew/homebrew-core/pull/2813
Grab part of https://github.com/fish-shell/fish-shell/commit/9abbc5f upstream commit and patch the makefile.
--- a/Makefile.in
+++ b/Makefile.in@@ -664,5 +664,5 @@ install-force: all install-translations
@@ -664,5 +664,5 @@ install-force: all install-translations
 	$(INSTALL) -m 755 -d $(DESTDIR)$(datadir)/fish/completions
-	$(INSTALL) -m 755 -d $(DESTDIR)$(extra_completionsdir)
-	$(INSTALL) -m 755 -d $(DESTDIR)$(extra_functionsdir)
-	$(INSTALL) -m 755 -d $(DESTDIR)$(extra_confdir)
+	$(INSTALL) -m 755 -d $(DESTDIR)$(extra_completionsdir); true
+	$(INSTALL) -m 755 -d $(DESTDIR)$(extra_functionsdir); true
+	$(INSTALL) -m 755 -d $(DESTDIR)$(extra_confdir); true
 	$(INSTALL) -m 755 -d $(DESTDIR)$(datadir)/fish/functions


