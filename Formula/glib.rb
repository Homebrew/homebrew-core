class Glib < Formula
  desc "Core application library for C"
  homepage "https://developer.gnome.org/glib/"
  url "https://download.gnome.org/sources/glib/2.58/glib-2.58.0.tar.xz"
  sha256 "c0f4ce0730b4f95c47b711613b5406a887c2ee13ea6d25930d72a4fa7fdb77f6"
  revision 1

  bottle do
    sha256 "ca271e3fc42d83b0c22223cf364c0d34ea201ec36b2c03dfe05ce495e9f9d565" => :mojave
    sha256 "566038e5b2e58c780d88958ad6db24dae4c36b66e75ee71c7cefade1bd1cdb5e" => :high_sierra
    sha256 "e7282881f1ea46e412a33ec44ac243397a799e8b5860c0cb7902dcb543adcb79" => :sierra
    sha256 "43065ecf5ea3d7c24f683313ef45a89ac9eac8a86f232729eeb58f36eca6384e" => :el_capitan
  end

  option "with-test", "Build a debug build and run tests. NOTE: Not all tests succeed yet"

  deprecated_option "test" => "with-test"

  depends_on "pkg-config" => :build
  # next three lines can be removed when bug 780271 is fixed and gio.patch is modified accordingly
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gtk-doc" => :build
  depends_on "gettext"
  depends_on "libffi"
  depends_on "pcre"

  # https://bugzilla.gnome.org/show_bug.cgi?id=673135 Resolved as wontfix,
  # but needed to fix an assumption about the location of the d-bus machine
  # id file.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/59e4d32/glib/hardcoded-paths.diff"
    sha256 "a4cb96b5861672ec0750cb30ecebe1d417d38052cac12fbb8a77dbf04a886fcb"
  end

  # Revert some bad macOS specific commits
  # https://bugzilla.gnome.org/show_bug.cgi?id=780271
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/5857984/glib/revert-appinfo-contenttype.patch"
    sha256 "88bfc2a69aaeda07c5f057d11e106a97837ff319f8be1f553b8537f3c136f48c"
  end

  def install
    inreplace %w[gio/gdbusprivate.c gio/xdgmime/xdgmime.c glib/gutils.c],
      "@@HOMEBREW_PREFIX@@", HOMEBREW_PREFIX

    # Disable dtrace; see https://trac.macports.org/ticket/30413
    args = %W[
      --disable-maintainer-mode
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-dtrace
      --disable-libelf
      --enable-static
      --prefix=#{prefix}
      --localstatedir=#{var}
      --with-gio-module-dir=#{HOMEBREW_PREFIX}/lib/gio/modules
    ]

    # next two lines can be removed when bug 780271 is fixed and gio.patch is modified accordingly
    ENV["NOCONFIGURE"] = "1"
    system "./autogen.sh"

    system "./configure", *args

    # disable creating directory for GIO_MODULE_DIR, we will do this manually in post_install
    inreplace "gio/Makefile", "$(mkinstalldirs) $(DESTDIR)$(GIO_MODULE_DIR)", ""

    # ensure giomoduledir contains prefix, as this pkgconfig variable will be used
    # by glib-networking and glib-openssl to determine where to install their modules
    inreplace "gio-2.0.pc", "giomoduledir=#{HOMEBREW_PREFIX}/lib/gio/modules", "giomoduledir=${prefix}/lib/gio/modules"

    system "make"
    # the spawn-multithreaded tests require more open files
    system "ulimit -n 1024; make check" if build.with? "test"
    system "make", "install"

    # `pkg-config --libs glib-2.0` includes -lintl, and gettext itself does not
    # have a pkgconfig file, so we add gettext lib and include paths here.
    gettext = Formula["gettext"].opt_prefix
    inreplace lib+"pkgconfig/glib-2.0.pc" do |s|
      s.gsub! "Libs: -L${libdir} -lglib-2.0 -lintl",
              "Libs: -L${libdir} -lglib-2.0 -L#{gettext}/lib -lintl"
      s.gsub! "Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include",
              "Cflags: -I${includedir}/glib-2.0 -I${libdir}/glib-2.0/include -I#{gettext}/include"
    end
  end

  def post_install
    (HOMEBREW_PREFIX/"lib/gio/modules").mkpath
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <string.h>
      #include <glib.h>

      int main(void)
      {
          gchar *result_1, *result_2;
          char *str = "string";

          result_1 = g_convert(str, strlen(str), "ASCII", "UTF-8", NULL, NULL, NULL);
          result_2 = g_convert(result_1, strlen(result_1), "UTF-8", "ASCII", NULL, NULL, NULL);

          return (strcmp(str, result_2) == 0) ? 0 : 1;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{include}/glib-2.0",
                   "-I#{lib}/glib-2.0/include", "-L#{lib}", "-lglib-2.0"
    system "./test"
  end
end
