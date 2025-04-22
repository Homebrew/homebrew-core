class Libffi < Formula
  desc "Portable Foreign Function Interface library"
  homepage "https://sourceware.org/libffi/"
  url "https://github.com/libffi/libffi/releases/download/v3.4.8/libffi-3.4.8.tar.gz"
  sha256 "bc9842a18898bfacb0ed1252c4febcc7e78fa139fd27fdc7a3e30d9d9356119b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "72cdf45be8925928df2c880faa24261b8a71dda1996caa50f4ce4bdf4d1e95f3"
    sha256 cellar: :any,                 arm64_sonoma:  "651001f28aaff71f1e5a8a5972a0c5580fb62dd6ea090303864e5ebec60567bb"
    sha256 cellar: :any,                 arm64_ventura: "cce541626d83ab0975f9d117d338ca430ce93dd6bd8a1e0a0da5db1e16043497"
    sha256 cellar: :any,                 sonoma:        "d90b539a53c4e58aca72ba735b7f25bcaa5b631b049ab4f49482e379210823ef"
    sha256 cellar: :any,                 ventura:       "f8ea26ec45f4a7a563cb81aa5c8fefb32741799e80819e8c8571cf9fd7c62b36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6771f1c17f35b6bee6748bbff759728ebfc9cb36155088fffe8f0f1e9d1b4c0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3dd4f7ce49728e37e9f8f868a8b85bdca6279b2f7781feb96b9e4bb400c18a0"
  end

  head do
    url "https://github.com/libffi/libffi.git", branch: "master"
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
