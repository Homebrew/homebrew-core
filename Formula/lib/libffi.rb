class Libffi < Formula
  desc "Portable Foreign Function Interface library"
  homepage "https://sourceware.org/libffi/"
  url "https://github.com/libffi/libffi/releases/download/v3.5.2/libffi-3.5.2.tar.gz"
  sha256 "f3a3082a23b37c293a4fcd1053147b371f2ff91fa7ea1b2a52e335676bac82dc"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "564ce412bbf20deb184e488fe9b1cbf94b5c770965e48567c829a5f580141a95"
    sha256 cellar: :any,                 arm64_sequoia: "e53361765ab81aa4bbead3bf1821678d4fb34b68355fe42f43032c7b99cf7224"
    sha256 cellar: :any,                 arm64_sonoma:  "b7080567d415b510513d3d83db312e530fd1b13d49cb9831fc5a67b9c531d0a3"
    sha256 cellar: :any,                 arm64_ventura: "a6eee79d333e8773beb401cb710a4ab26380c2e14d7f90583b92ac87328c6ab4"
    sha256 cellar: :any,                 sonoma:        "4d9e57a4b8bb66b3dd966a931b0be8e916b2587bec5886b8af519dcafe276b13"
    sha256 cellar: :any,                 ventura:       "4b53c8b6527e22e65de26598797eb3ec2402c152295a34b5e31149e9376a0e02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85cdf235032a05637b9b30c3deb0d14c7673a3aefe97fed3c6d781c159d89a9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55b77eb2bb125870f6e1ec41e4717f0bc7c7fe294e41b59aaef006be6bdf60bd"
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
