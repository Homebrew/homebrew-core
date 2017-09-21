class EasyTag < Formula
  desc "Application for viewing and editing audio file tags"
  homepage "https://projects.gnome.org/easytag"
  url "https://download.gnome.org//sources/easytag/2.4/easytag-2.4.3.tar.xz"
  sha256 "fc51ee92a705e3c5979dff1655f7496effb68b98f1ada0547e8cbbc033b67dd5"

  bottle do
    sha256 "3fcdf749053a1b167fb794a0594f2d0e3e8b39abb6c667fde128a219023525b1" => :high_sierra
    sha256 "d20f399c5972fa22c9d7cd4e932fa0ee06aed3d47bdfc1a8e8f113182db844d2" => :sierra
    sha256 "d69715f30682f6444a8c4846cb240de0d73d8c8c554ab9bebf2d8fdbed562a97" => :el_capitan
    sha256 "341ef4c5ac80879f7d187e977e63dd446382bbcd0b210d4100f6794261486ea2" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "gnome-icon-theme"
  depends_on "id3lib"
  depends_on "libid3tag"
  depends_on "taglib"

  depends_on "libvorbis"
  depends_on "flac"
  depends_on "libogg"
  depends_on "speex"
  depends_on "wavpack"

  # disable gtk-update-icon-cache
  patch :DATA

  def install
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python2.7/site-packages"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile"
    system "make"
    ENV.deparallelize # make install fails in parallel
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/easytag", "--version"
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index 9dbde5f..4ffe52e 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -3960,8 +3960,6 @@ data/org.gnome.EasyTAG.gschema.valid: data/.dstamp
 @ENABLE_MAN_TRUE@		--path $(builddir)/doc --output $(builddir)/doc/ \
 @ENABLE_MAN_TRUE@		http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl $<

-install-data-hook: install-update-icon-cache
-uninstall-hook: uninstall-update-icon-cache

 install-update-icon-cache:
	$(AM_V_at)$(POST_INSTALL)
