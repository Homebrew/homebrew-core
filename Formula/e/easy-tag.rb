class EasyTag < Formula
  desc "Application for viewing and editing audio file tags"
  homepage "https://wiki.gnome.org/Apps/EasyTAG"
  url "https://download.gnome.org/sources/easytag/2.4/easytag-2.4.3.tar.xz"
  sha256 "fc51ee92a705e3c5979dff1655f7496effb68b98f1ada0547e8cbbc033b67dd5"
  license "GPL-2.0-or-later"
  revision 8

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "75ad62d58aff7e29d22b9da39515f3c7685cc644ffd7805f63deabb25d769e6a"
    sha256 arm64_ventura:  "2842fbc4cf1533ae7f7734797839ef1658526719b4050a4293f9cbe57af6b88d"
    sha256 arm64_monterey: "62610eeb362c3239309e9559cf01632f86c4c3b55b119aec1c4b8f79fbd5ce9d"
    sha256 arm64_big_sur:  "b9e4f4fb767f1bcacaa1fa4f527814681d92ce47d7d091f22e3bb506f7e4c3f7"
    sha256 sonoma:         "a0f488a8f3897c8770fe4144a425cbb724c94208060794665b4751215110de33"
    sha256 ventura:        "d79741edf9f1f7351596ee388e1fc4b80f0e817f66b1f63303ae7c33e99dfbb6"
    sha256 monterey:       "e07457b1fe81c61d43908dae2964dba03e56631e4788f1546c194079c7be2ddb"
    sha256 big_sur:        "51c76274e95501746d8f92476e2d9d9fe4163b00f2750ba9e703e8b4e8c0f670"
    sha256 x86_64_linux:   "2990dcdd7b0c5eb9c23aa7bb3af2720d8ead25ef00ae9d2f6edf5004d32526e1"
  end

  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
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
