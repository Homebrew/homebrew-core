class EasyTag < Formula
  desc "Application for viewing and editing audio file tags"
  homepage "https://wiki.gnome.org/Apps/EasyTAG"
  url "https://download.gnome.org/sources/easytag/2.4/easytag-2.4.3.tar.xz"
  sha256 "fc51ee92a705e3c5979dff1655f7496effb68b98f1ada0547e8cbbc033b67dd5"
  license "GPL-2.0-or-later"
  revision 8

  bottle do
    sha256 arm64_monterey: "ca7de92bfc1f678e343fa737d0abe7d4cf1a160368be111b660ace255f1361ff"
    sha256 arm64_big_sur:  "fd1e0926e653a9eaa1b63a161dbe7ae0eae3e171e620f950ddcde775ddf5bb3f"
    sha256 monterey:       "e571ff28075c32f8000077ee72c8dc42e3c2f6672c49529f839654d714b1b2c5"
    sha256 big_sur:        "8b8a031780716d40c2fe94d3aeb99af65cfc76332c2b84abbe0f8b605884f167"
    sha256 catalina:       "ec5fc6eadc609d57416fc3dcdfe43bdc040d8551ff06d667ced1a3c75a84ba2e"
    sha256 x86_64_linux:   "81469f87d139ffb0926e2ee2e296708d46cf9cfc3af77c2f28db80bfac9c0c14"
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
