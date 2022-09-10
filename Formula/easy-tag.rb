class EasyTag < Formula
  desc "Application for viewing and editing audio file tags"
  homepage "https://wiki.gnome.org/Apps/EasyTAG"
  url "https://download.gnome.org/sources/easytag/2.4/easytag-2.4.3.tar.xz"
  sha256 "fc51ee92a705e3c5979dff1655f7496effb68b98f1ada0547e8cbbc033b67dd5"
  license "GPL-2.0-or-later"
  revision 8

  bottle do
    sha256 arm64_monterey: "0e334fc2c5c63aa37ca2a591a7fd8766971c5968182bf9a54f65341ca68aa26e"
    sha256 arm64_big_sur:  "19c855890bd69d2f3b43474643f0549471fddb21a7bd9028f7a3c79eb1b3babc"
    sha256 monterey:       "bdfb1e89623fd2c2768838c25e1dbee94df3dfddee44ac909981016fbdaa511a"
    sha256 big_sur:        "90aaef272ceccc7649f07c4f28f035bf244c46b2d2759fb1f20b4461dc1ddaf5"
    sha256 catalina:       "e54ae5171bfd60214766706fc9442d3824c6ce0b29e989060496341bf5844295"
    sha256 x86_64_linux:   "2138a2a771d53f468b4aca39464f049106901b0645532a8b1b63ad2da33c98f6"
  end

  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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
    ENV.append_path "PYTHONPATH", Formula["libxml2"].opt_prefix/Language::Python.site_packages("python3")
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?
    ENV.append "LDFLAGS", "-lz"

    system "./configure", *std_configure_args, "--disable-schemas-compile"
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
