class Libffi < Formula
  desc "Portable Foreign Function Interface library"
  homepage "https://sourceware.org/libffi/"
  url "https://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/libf/libffi/libffi_3.2.1.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/libf/libffi/libffi_3.2.1.orig.tar.gz"
  sha256 "d06ebb8e1d9a22d19e38d63fdb83954253f39bedc5d46232a05645685722ca37"

  bottle do
    cellar :any
    sha256 "8d9b153f501fcc5103bb96b00be9a1aea6a0c09e5d61b9acfb998546c3301582" => :mojave
    sha256 "c63fbf004a3c314b7af3bd6b8fc50dc33c06730235cf7e245cb206307dca0933" => :high_sierra
    sha256 "13836da147e311ac2920df5a1d0f04b672ce89204334b5e0233b428572860483" => :sierra
    sha256 "82e5176c758030c4d7571ebd7b412624eed28b8379069c27e366952569168bda" => :el_capitan
    sha256 "9047ca06422e869790ec80adf37cedb3eff6e422094bde0371e24d9bb18dc3f0" => :yosemite
  end

  head do
    url "https://github.com/atgreen/libffi.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos, "some formulae require a newer version of libffi"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
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

    flags = ["-L#{lib}", "-lffi", "-I#{lib}/libffi-#{version}/include"]
    system ENV.cc, "-o", "closure", "closure.c", *(flags + ENV.cflags.to_s.split)
    system "./closure"
  end
end
