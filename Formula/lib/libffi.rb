class Libffi < Formula
  desc "Portable Foreign Function Interface library"
  homepage "https://sourceware.org/libffi/"
  url "https://github.com/libffi/libffi/releases/download/v3.7.0/libffi-3.7.0.tar.gz"
  sha256 "2255c5a638dfb51bf67c20a12a7bb70d17feb1e9eababac05f5573146f586436"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "03ebef0e81ab3b5a73f81e01a11b2c576aedd5da0b87430277b0a6236c3e53ee"
    sha256 cellar: :any, arm64_sequoia: "975e8e28319c76760af2479d55dcab30edd56459366dc010c5d0c7a7bc1e673f"
    sha256 cellar: :any, arm64_sonoma:  "cde4ff48efd082292b12bedb00c87702d60462493cd85c2669fcf6a8cb5a7101"
    sha256 cellar: :any, sonoma:        "33c71923557a412df8fc9330279edc8fc9e6576ca71d31d21c2ec77c66d80b1d"
    sha256 cellar: :any, arm64_linux:   "14b1f9fa557128f85c99a4143075d80e724c5595c7fb93f82dd0f2cfc53cabbc"
    sha256 cellar: :any, x86_64_linux:  "482837fc709a54deea16f36b9f10a7109fe0f833bf96ca5c62b26377a1aa078e"
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
