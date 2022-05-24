class EasyTag < Formula
  desc "Application for viewing and editing audio file tags"
  homepage "https://wiki.gnome.org/Apps/EasyTAG"
  url "https://download.gnome.org/sources/easytag/2.4/easytag-2.4.3.tar.xz"
  sha256 "fc51ee92a705e3c5979dff1655f7496effb68b98f1ada0547e8cbbc033b67dd5"
  license "GPL-2.0-or-later"
  revision 6

  bottle do
    sha256 arm64_monterey: "39d4f47a2a8310fbef48070f247e2ec45cc0761bf5e1baa8ebda5446e1aee0b4"
    sha256 arm64_big_sur:  "8a1cef2c91b3216179ce0eb8ace40e845c2956bb08602747d9c4b433b8c138e2"
    sha256 monterey:       "d0ef9d0bc6d61b5c2c68b1f26d363a1ed2fd95c5dbe671e6492e94db032d9b3d"
    sha256 big_sur:        "f10db53f7c6852dc2d83920c64b5166612b7ebfcfd8b8789228bcc2917b183c4"
    sha256 catalina:       "cf12b241113c19be8fb1b91871d0428f29c9d4e39066c5fd0c197bba1f12088a"
    sha256 x86_64_linux:   "f33415cd657483d9eea16b2d51d12938cb2cc2296662c0761142ad760f5c21c4"
  end

  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "adwaita-icon-theme"
  depends_on "flac"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "id3lib"
  depends_on "libid3tag"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "speex"
  depends_on "taglib"
  depends_on "wavpack"

  uses_from_macos "perl" => :build

  # disable gtk-update-icon-cache
  patch :DATA

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python#{xy}/site-packages"
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?
    ENV.append "LDFLAGS", "-lz"

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
    # Disable test on Linux because it fails with:
    # Gtk-WARNING **: 18:38:23.471: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

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
