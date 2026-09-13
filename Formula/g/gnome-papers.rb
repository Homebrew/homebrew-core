class GnomePapers < Formula
  desc "Document viewer for PDF and other document formats aimed at the GNOME desktop"
  homepage "https://apps.gnome.org/Papers/"
  url "https://download.gnome.org/sources/papers/50/papers-50.3.tar.xz"
  sha256 "3ed2b22d4894351f02441e8688a0603b651226bfd510129f952780035e3ad24a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_golden_gate: "94a02b294be6eae6f508d6586ebe2d0afeedd9d5be27b52804cf422907e429df"
    sha256 arm64_tahoe:       "c8ea0c842a963fb9f34ebe1fa38da1da6708a84bbc634d5da389a766aa3035af"
    sha256 arm64_sequoia:     "669321cb3e7fa36810bcc4062a8e4412c5919ab6a9d3b8734ce249c164056735"
    sha256 arm64_linux:       "761e6b5a9ecacefe02d8eb2fea00b5aeb728fe2cc4d1456fb5e133e275d28627"
    sha256 x86_64_linux:      "ad8fcd56121001a2e0ed52ea036b9422bf4208c94e34f8c14ec593a843975997"
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
    update_gtk_icon_cache
  end

  test do
    resource "test-pdf" do
      url "https://gitlab.freedesktop.org/poppler/test/-/raw/1aca8a13eeaa37403f9330febcb4745affcfd139/tests/text.pdf"
      sha256 "9fac4cf9ac688f067ee38ddddcf9f237d4f6adf29601672e4ef1765c63997880"
    end

    resource("test-pdf").stage testpath
    (testpath/"test.c").write <<~C
      #include <fcntl.h>
      #include <glib.h>
      #define I_KNOW_THE_PAPERS_LIBS_ARE_UNSTABLE_AND_HAVE_TALKED_WITH_THE_AUTHORS
      #include <papers-document.h>
      #include <papers-view.h>

      int main(void) {
        g_autoptr(GError) error = NULL;
        g_autoptr(PpsJob) job = NULL;
        g_autoptr(PpsDocument) document = NULL;
        g_autoptr(PpsPage) page = NULL;
        int fd;
        gint n_pages;
        gboolean has_backend;

        has_backend = pps_init();
        g_assert_true(has_backend);

        fd = open("text.pdf", O_RDONLY);
        g_assert_cmpint(fd, !=, -1);

        job = pps_job_load_new();
        g_assert_nonnull(job);

        /* Pass the MIME type explicitly; sniffing it needs a MIME database or LaunchServices */
        pps_job_load_take_fd(PPS_JOB_LOAD(job), fd, "application/pdf");
        pps_job_run(job);
        pps_job_is_succeeded(job, &error);
        g_assert_no_error(error);

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
