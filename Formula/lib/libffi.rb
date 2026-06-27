class Libffi < Formula
  desc "Portable Foreign Function Interface library"
  homepage "https://sourceware.org/libffi/"
  url "https://github.com/libffi/libffi/releases/download/v3.6.0/libffi-3.6.0.tar.gz"
  sha256 "31ff1fe32deaebfbb388727f32677bb254bf2a41382c51464c0b1837c9ee9828"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1f96862811dfc633265945abd4ecf85c9c7e7bf255824d12578965e2551e53f2"
    sha256 cellar: :any, arm64_sequoia: "522d348ce5048fa6c9aed16a57b1de28e470d154b19cd59014ee9c2b3243d34e"
    sha256 cellar: :any, arm64_sonoma:  "4075c3e21a12c35955cd21281aaa05428f77360903d231f87e4226b92f7a53ad"
    sha256 cellar: :any, sonoma:        "d4ceadacb73731f3a76a7c8919158e5d8ac7c34593ef69dfa050f72d6d775397"
    sha256 cellar: :any, arm64_linux:   "df3d67130f72af501810fe5d82702ec1aca5384b4e2a9b515018a3c289ee6179"
    sha256 cellar: :any, x86_64_linux:  "23e92620d6b69468f0f73d23b53e1fe49bca9aca8ab6106fa431887d2b42c37e"
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
