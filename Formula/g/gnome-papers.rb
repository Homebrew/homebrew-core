class GnomePapers < Formula
  desc "Document viewer for PDF and other document formats aimed at the GNOME desktop"
  homepage "https://apps.gnome.org/Papers/"
  url "https://download.gnome.org/sources/papers/50/papers-50.2.tar.xz"
  sha256 "ae1bdcf1cd47cb50c9d84765784607f81c72df17dd6e6ad933fea14173d2b9f4"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "3f7bb27f681c69012d108287647ae77c02ad7b56be6d60477aa70f39bc4d0486"
    sha256 arm64_sequoia: "0a7eb9f5d98d177e80765e227713aea126a80f02864e27e72776dbba9c3fc046"
    sha256 arm64_sonoma:  "feb32fc65382b39775ee259b439866b6d04715d216a334c4de2a9206b5a87b11"
    sha256 sonoma:        "b02a90873c3167c99796f386f3db964fc49a214271dc599ed2fe44d2cdde2cff"
    sha256 arm64_linux:   "24661722391d382acff3ae510a5f18cddff50e849fa97bdd5ee142cf483fae90"
    sha256 x86_64_linux:  "290f60f324b8222008683b05d02dc55495f0f76f04c3394ffe58b635e4a0a3b8"
  end

  depends_on "blueprint-compiler" => :build
  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build # for msgfmt
  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.14" => :build # For blueprint-compiler
  depends_on "rust" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "djvulibre"
  depends_on "exempi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "hicolor-icon-theme"
  depends_on "libadwaita"
  depends_on "libarchive"
  depends_on "libspelling"
  depends_on "libtiff"
  depends_on "pango"
  depends_on "poppler"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  def install
    ENV["DESTDIR"] = "/"

    if OS.mac?
      # https://github.com/gettext-rs/gettext-rs/tree/master/gettext-sys#environment-variables
      ENV["GETTEXT_DIR"] = Formula["gettext"].prefix.to_s

      ENV.append_to_rustflags "--codegen link-args=-Wl,-rpath,#{rpath}"
    end

    args = %w[
      -Dshell=true
      -Dpreviewer=true
      -Dthumbnailer=true
      -Dnautilus=false
      -Dcomics=enabled
      -Ddjvu=enabled
      -Dpdf=enabled
      -Dtiff=enabled
      -Dtests=false
      -Ddocumentation=false
      -Duser_doc=false
      -Dintrospection=enabled
      -Dsysprof=disabled
      -Dkeyring=enabled
      -Dgtk_unix_print=enabled
      -Dspell_check=enabled
      -Dfile_tests=false
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    compile_gsettings_schemas
    gtk_update_icon_cache
  end

  test do
    resource "test-pdf" do
      url "https://gitlab.freedesktop.org/poppler/test/-/raw/1aca8a13eeaa37403f9330febcb4745affcfd139/tests/text.pdf"
      sha256 "9fac4cf9ac688f067ee38ddddcf9f237d4f6adf29601672e4ef1765c63997880"
    end

    resource("test-pdf").stage testpath
    (testpath/"test.c").write <<~C
      #include <glib.h>
      #define I_KNOW_THE_PAPERS_LIBS_ARE_UNSTABLE_AND_HAVE_TALKED_WITH_THE_AUTHORS
      #include <papers-document.h>
      #include <papers-view.h>

      int main(void) {
        g_autoptr(GFile) file = NULL;
        g_autoptr(PpsJob) job = NULL;
        g_autoptr(PpsDocument) document = NULL;
        g_autoptr(PpsPage) page = NULL;
        g_autofree gchar *uri = NULL;
        const gchar *file_path = "text.pdf";
        gint n_pages;
        gboolean has_backend;

        has_backend = pps_init();
        g_assert_true(has_backend);

        file = g_file_new_for_path(file_path);
        g_assert_nonnull(file);

        uri = g_file_get_uri(file);
        g_assert_nonnull(uri);

        job = pps_job_load_new();
        g_assert_nonnull(job);

        pps_job_load_set_uri(PPS_JOB_LOAD(job), uri);
        pps_job_run(job);

        document = pps_job_load_get_loaded_document(PPS_JOB_LOAD(job));
        g_assert_nonnull(document);

        n_pages = pps_document_get_n_pages(document);
        g_assert(n_pages == 1);

        page = pps_document_get_page(document, 0);
        g_assert_nonnull(page);

        pps_shutdown();

        return 0;
      }
    C
    pkg_config_flags = shell_output("pkg-config --cflags --libs papers-document-4.0 papers-view-4.0").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags
    system "./a.out"
    assert_match version.to_s, shell_output("#{bin}/papers --version")
  end
end
