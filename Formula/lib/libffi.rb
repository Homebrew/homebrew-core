class Libffi < Formula
  desc "Portable Foreign Function Interface library"
  homepage "https://sourceware.org/libffi/"
  url "https://github.com/libffi/libffi/releases/download/v3.7.1/libffi-3.7.1.tar.gz"
  sha256 "d5e9a6638ddbd2513ddb54518eb67e4bbe6fa707bcc01c10f6212f0a088d819d"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "083d67dec69dc4366f58310a6b3a333ca04b4a56ddf0822c03cdd485b350ee20"
    sha256 cellar: :any, arm64_sequoia: "1bf93e286a67d5f2d2db0bd071d2f22648bc6bfe722e4dbe8e99399e4e5c10b8"
    sha256 cellar: :any, arm64_sonoma:  "a6ddf558ee5bc1dd8fffc983ea0e9d88324a39e474080817bc3277653a1b958c"
    sha256 cellar: :any, sonoma:        "9f796fc57f506209208c474f4d1dc0082d683babece6aad26d4ef68d01944358"
    sha256 cellar: :any, arm64_linux:   "0448b10c377ee5f3f531b830d9725ced15bbd1843b779615f46ddfcce9e2bb02"
    sha256 cellar: :any, x86_64_linux:  "d38ed5eba118dc170bede46cf32fe5aae43f3ce919daef0de0181af0cf0a000f"
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
