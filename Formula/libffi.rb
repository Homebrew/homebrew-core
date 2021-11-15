class Libffi < Formula
  desc "Portable Foreign Function Interface library"
  homepage "https://sourceware.org/libffi/"
  url "https://github.com/libffi/libffi/releases/download/v3.4.2/libffi-3.4.2.tar.gz"
  sha256 "540fb721619a6aba3bdeef7d940d8e9e0e6d2c193595bc243241b77ff9e93620"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6a3605cff713d45e0500ef01c0f082d1b4d31d70cd2400b5856443050a44a056"
    sha256 cellar: :any,                 arm64_big_sur:  "2166e9d5178197a84ec721b40e22d8c42e30bd0c4808bd38b1ca768eb03f62a5"
    sha256 cellar: :any,                 monterey:       "d2cee9b7c8158cf7164fc58c4c5054e38898caefd5f902d36996e1c362d936bc"
    sha256 cellar: :any,                 big_sur:        "a461f6ad21a23a725691385dbbec3eff958cf61d5282e84dc3f0483e307e1875"
    sha256 cellar: :any,                 catalina:       "6dbeaf8209b24c0963a5c87cd99d68f8bf61ea532c1c55bec8467a621b64da1b"
    sha256 cellar: :any,                 mojave:         "ebd8f12d294d0194f4bfd158cc20b454ff97c02def465cb4cd69eea621665033"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48e34a380ab065bda9191298bd3eefc895f1c2315d508cb83614eac01cf38301"
  end

  head do
    url "https://github.com/libffi/libffi.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"closure.c").write <<~EOS
      #include <stdio.h>
      #include <ffi.h>

      /* Acts like puts with the file given at time of enclosure. */
      void puts_binding(ffi_cif *cif, unsigned int *ret, void* args[],
                        FILE *stream)
      {
        *ret = fputs(*(char **)args[0], stream);
      }

      int main()
      {
        ffi_cif cif;
        ffi_type *args[1];
        ffi_closure *closure;

        int (*bound_puts)(char *);
        int rc;

        /* Allocate closure and bound_puts */
        closure = ffi_closure_alloc(sizeof(ffi_closure), &bound_puts);

        if (closure)
          {
            /* Initialize the argument info vectors */
            args[0] = &ffi_type_pointer;

            /* Initialize the cif */
            if (ffi_prep_cif(&cif, FFI_DEFAULT_ABI, 1,
                             &ffi_type_uint, args) == FFI_OK)
              {
                /* Initialize the closure, setting stream to stdout */
                if (ffi_prep_closure_loc(closure, &cif, puts_binding,
                                         stdout, bound_puts) == FFI_OK)
                  {
                    rc = bound_puts("Hello World!");
                    /* rc now holds the result of the call to fputs */
                  }
              }
          }

        /* Deallocate both closure, and bound_puts */
        ffi_closure_free(closure);

        return 0;
      }
    EOS

    flags = ["-L#{lib}", "-lffi", "-I#{include}"]
    system ENV.cc, "-o", "closure", "closure.c", *(flags + ENV.cflags.to_s.split)
    system "./closure"
  end
end
