require File.expand_path("../../Abstract/portable-formula", __dir__)

class PortableLibffi < PortableFormula
  desc "Portable Foreign Function Interface library"
  homepage "https://sourceware.org/libffi/"
  url "https://github.com/libffi/libffi/releases/download/v3.5.2/libffi-3.5.2.tar.gz"
  sha256 "f3a3082a23b37c293a4fcd1053147b371f2ff91fa7ea1b2a52e335676bac82dc"
  license "MIT"

  livecheck do
    formula "libffi"
  end

  def install
    system "./configure", *portable_configure_args,
                          *std_configure_args,
                          "--enable-static",
                          "--disable-shared",
                          "--disable-docs"
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
