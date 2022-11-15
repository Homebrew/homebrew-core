class Libffi < Formula
  desc "Portable Foreign Function Interface library"
  homepage "https://sourceware.org/libffi/"
  url "https://github.com/libffi/libffi/releases/download/v3.4.4/libffi-3.4.4.tar.gz"
  sha256 "d66c56ad259a82cf2a9dfc408b32bf5da52371500b84745f7fb8b645712df676"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "66d9dcb218283c43250b04e507b7b96f0cf18fb1017fcaf811729324d11127f7"
    sha256 cellar: :any,                 arm64_monterey: "e7ea0921a053dc81e818c3893887e819ed26c0e231fd306e05e905b51b9ea902"
    sha256 cellar: :any,                 arm64_big_sur:  "8d44b24963c114512934de23cc776a6190f5bcb65db8e6cc65e1b60122571747"
    sha256 cellar: :any,                 ventura:        "a86ed7eb1b02a3d44cd6e75977c910466357a1715743f89be94416d000577133"
    sha256 cellar: :any,                 monterey:       "9dd80c4c3d4451cc3216dbf1129a2bddec474aa9266b6bb5c603e0a6cce7605b"
    sha256 cellar: :any,                 big_sur:        "b5c4e2054802f97a68b8f32d9ff2c6782f9a37223cd0a3b3d2175ecf04740a4f"
    sha256 cellar: :any,                 catalina:       "1f53646211da139b423eb38f923bc38da1de86b7a68bfc2df5351098fe3c67e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcc9412995b5e319f64796a77b1eb8e684f1d1b6b5d7ac824f434ada692e4ff8"
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
