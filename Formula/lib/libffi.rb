class Libffi < Formula
  desc "Portable Foreign Function Interface library"
  homepage "https://sourceware.org/libffi/"
  url "https://github.com/libffi/libffi/releases/download/v3.8.2/libffi-3.8.2.tar.gz"
  sha256 "a699fda2b090c4b46cb79cf60c4dacfce480eb05742c0de66acf3af174a47f92"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "7fb193ab2f492b34066b1b6b782ca49e91749ca91e93308b08ab48b010019bd4"
    sha256 cellar: :any, arm64_golden_gate: "e3521df27c773ef19952a8c241b6f7ed63af6e87565ba6abfa1f712f1a399a68"
    sha256 cellar: :any, arm64_tahoe:       "08692721f41aeaa0c29108814fa9685111e52da401ee6353c7becc8fc9af2c2f"
    sha256 cellar: :any, arm64_sequoia:     "ed031e1b9cea850906cccd747fdf9c3043d1b45a59a36e5823264b918162c973"
    sha256 cellar: :any, arm64_linux:       "1b261d36e12abb3d24719c82bb5a3c1878df4c7bf4dc05f31f956bd07648e35f"
    sha256 cellar: :any, x86_64_linux:      "e1cb062cc041eed46c0030ea483ba517f69d258e4cfeb5bbed02fd496d8faab5"
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
