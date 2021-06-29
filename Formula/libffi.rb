class Libffi < Formula
  desc "Portable Foreign Function Interface library"
  homepage "https://sourceware.org/libffi/"
  url "https://github.com/libffi/libffi/releases/download/v3.4.2/libffi-3.4.2.tar.gz"
  sha256 "540fb721619a6aba3bdeef7d940d8e9e0e6d2c193595bc243241b77ff9e93620"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "10a6d66c264f9a23d1162e535fe49f27c23f6ef452b4701ed7110f06aaf1e01d"
    sha256 cellar: :any,                 big_sur:       "8a7a02cffb368dfdeaeb1176a7a7bcc6402371aee0a30bb001aff3452a4202c6"
    sha256 cellar: :any,                 catalina:      "66caa8a807684ce5d5173ffc4db1eaa7167eabd634335a2ce3b8ba667efe2686"
    sha256 cellar: :any,                 mojave:        "1205c19a1d51940726534923db0e1c291b001a3ea541d0694afccad7968343a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fab61c20c0548c253b2d873b4d69b2c1a23b61d2a7868a4a0fdcf11e95e6375f"
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
