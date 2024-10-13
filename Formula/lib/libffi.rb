class Libffi < Formula
  desc "Portable Foreign Function Interface library"
  homepage "https://sourceware.org/libffi/"
  url "https://github.com/libffi/libffi/releases/download/v3.4.6/libffi-3.4.6.tar.gz"
  sha256 "b0dea9df23c863a7a50e825440f3ebffabd65df1497108e5d437747843895a4e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "3c98bcb95fbcf46bdc04e0bdc87c5253a8f965edc8da1f1fe1213a9e438abc7e"
    sha256 cellar: :any,                 arm64_sonoma:   "e81237234a3e21d5222c1c8baf4017bc2f2ad7e444fbf58ad6b635fc0ace5078"
    sha256 cellar: :any,                 arm64_ventura:  "7a6a1d1dffe41d4e9bf117440190be51c432a2a192945ed8e2e10c4bb1f95ad0"
    sha256 cellar: :any,                 arm64_monterey: "eacdfea3b29d48dc8c3fb7578a9a59dbeb9048eca6493b8cd95605c86652e6de"
    sha256 cellar: :any,                 sonoma:         "d783974753df1f7347d8cef16403e157f0625302848e8267626064c4f79a97d8"
    sha256 cellar: :any,                 ventura:        "e5adecfb6ddd1a18ccb492c051adfd693eb091c4b24a58ad7b1cecb6afb0a575"
    sha256 cellar: :any,                 monterey:       "8b3cb29277a584f1684661823c8232659b04234873430164bc80ba484c8aa8da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "798c3983a917698d5dd0c60063e7b8c1e5b4fc377d9e11d7cba010725eca1bfb"
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
    (testpath/"closure.c").write <<~EOS
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
    EOS

    flags = ["-L#{lib}", "-lffi", "-I#{include}"]
    system ENV.cc, "-o", "closure", "closure.c", *(flags + ENV.cflags.to_s.split)
    system "./closure"
  end
end
