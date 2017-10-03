class Glib < Formula
  desc "Core application library for C"
  homepage "https://developer.gnome.org/glib/"
  url "https://download.gnome.org/sources/glib/2.54/glib-2.54.1.tar.xz"
  sha256 "50c01b1419324f10fbf9b9709ec2164b18586968bdce7540583bf32302cf47a3"

  bottle do
    sha256 "a273e1a2a709ee897feab679ebf088fe308d796dbe54ca589d9dd5b8de981809" => :high_sierra
    sha256 "bfeb6d10a3e46eb8529716a5ce3bb772415085278f5daa17d2f6cd25a489cc3b" => :sierra
    sha256 "7fd194b14cc5558cde76abbe17e017b5b7f3139b16b27e635313ff138945da9b" => :el_capitan
  end

  option "with-test", "Build a debug build and run tests. NOTE: Not all tests succeed yet"

  deprecated_option "test" => "with-test"

  depends_on "pkg-config" => :build
  # next three lines can be removed when bug 780271 is fixed and gio.patch is modified accordingly
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
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

  # Fixes compilation with FSF GCC. Doesn't fix it on every platform, due
  # to unrelated issues in GCC, but improves the situation.
  # Patch submitted upstream: https://bugzilla.gnome.org/show_bug.cgi?id=672777
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/13efbb2/glib/gio.patch"
    sha256 "628f8ea171a29c67fb06461ce4cfe549846b8fe64d83466e18e225726615b997"
  end

  # Revert some bad macOS specific commits
  # https://bugzilla.gnome.org/show_bug.cgi?id=780271
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/73738ca/glib/revert-appinfo-contenttype.patch"
    sha256 "675369c6d956b5533865178a2a78a6b2dcb921fbcfd81d35e92fc1592323e5e4"
  end

  def install
    inreplace %w[gio/gdbusprivate.c gio/xdgmime/xdgmime.c glib/gutils.c],
      "@@HOMEBREW_PREFIX@@", HOMEBREW_PREFIX

    # renaming is necessary for patches to work
    mv "gio/gcocoanotificationbackend.c", "gio/gcocoanotificationbackend.m"
    mv "gio/gnextstepsettingsbackend.c", "gio/gnextstepsettingsbackend.m"
    rm "gio/gosxappinfo.h"

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

    # next line can be removed when bug 780271 is fixed and gio.patch is modified accordingly
    system "autoreconf", "-i", "-f"

    system "./configure", *args

    # disable creating directory for GIO_MODULE_DIR, we will do this manually in post_install
    inreplace "gio/Makefile", "$(mkinstalldirs) $(DESTDIR)$(GIO_MODULE_DIR)", ""

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

    (share+"gtk-doc").rmtree
  end

  def post_install
    (HOMEBREW_PREFIX/"lib/gio/modules").mkpath
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
