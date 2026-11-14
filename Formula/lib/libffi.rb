class Libffi < Formula
  desc "Portable Foreign Function Interface library"
  homepage "https://sourceware.org/libffi/"
  url "https://github.com/libffi/libffi/releases/download/v3.8.1/libffi-3.8.1.tar.gz"
  sha256 "81e879c094cc5ec3186c48510c6385ac6b3e866192e8bc71a35245703757ee40"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9e9863c6a383c3d0d12166ffcbc52647287bad5215542ea5ec73233d69c7828a"
    sha256 cellar: :any, arm64_tahoe:       "d4e31f96513d447db79bbee4c7c97be303964be636772957521c6a5e3ae01a6a"
    sha256 cellar: :any, arm64_sequoia:     "b8c2e7ea5bddf49536a5394b3fc880ad8731177dbd3f7333081ba587e5634a7a"
    sha256 cellar: :any, arm64_linux:       "0f67262b2617146853a072b974573a291cd14064b8b1996192cdc7127a95acf7"
    sha256 cellar: :any, x86_64_linux:      "a719469ecf057ea71637b5cf198f91bd90af4c3816ddbf5cf44b3b6fb7f67346"
  end

  head do
    url "https://github.com/libffi/libffi.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  deny_network_access!

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"closure.c").write <<~C
      #include <stdio.h>
      #include <ffi.h>

      /* Acts like puts with the file given at time of enclosure. */
      void puts_binding(ffi_cif *cif, void *ret, void** args, void *stream)
      {
        *(unsigned int *)ret = fputs(*(char **)args[0], (FILE *)stream);
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
    C

    flags = ["-L#{lib}", "-lffi", "-I#{include}"]
    system ENV.cc, "-o", "closure", "closure.c", *(flags + ENV.cflags.to_s.split)
    system "./closure"
  end
end
