class Libffi < Formula
  desc "Portable Foreign Function Interface library"
  homepage "https://sourceware.org/libffi/"
  url "https://github.com/libffi/libffi/releases/download/v3.4.3/libffi-3.4.3.tar.gz"
  sha256 "4416dd92b6ae8fcb5b10421e711c4d3cb31203d77521a77d85d0102311e6c3b8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "da9471634d8a66ea91002692497e5db2327ef1c9ca788a8522a0bf8534dccac3"
    sha256 cellar: :any,                 arm64_big_sur:  "4bb30919db7aeb02703e33ce81a6b04575c9bddd976c4ce1b8166605f318a752"
    sha256 cellar: :any,                 monterey:       "1d0154601d1960b54e6a95b41e85693fab93989c4dbb8245cd0e92d97d6c0a8f"
    sha256 cellar: :any,                 big_sur:        "efe89f7d3bd7a216ba7e051e25b89476b63b466ef6322e37a533582623446b31"
    sha256 cellar: :any,                 catalina:       "4de78fb4c0ce27fa67c7c576a4b337333eb0def882fca332618cde7fa2d92765"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "453a11abc7235f9c475b4eb9ba9acec4b561ec6970c942ecfb8d25b4c68675f8"
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
