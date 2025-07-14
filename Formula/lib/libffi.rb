class Libffi < Formula
  desc "Portable Foreign Function Interface library"
  homepage "https://sourceware.org/libffi/"
  url "https://github.com/libffi/libffi/releases/download/v3.5.1/libffi-3.5.1.tar.gz"
  sha256 "f99eb68a67c7d54866b7706af245e87ba060d419a062474b456d3bc8d4abdbd1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "48eb150271830a3c7da1a28485bd7252c38de09764485b25cf90c0ec93a20be5"
    sha256 cellar: :any,                 arm64_sonoma:  "45087c0c963358486ef2b1ef0d40ddb20ec63e7fb3b921d8a3568891be8b4b48"
    sha256 cellar: :any,                 arm64_ventura: "87b515b6ce34421bbb4d4dfacb5b915ba36d73fb1465389ad74c56880c0d85ac"
    sha256 cellar: :any,                 sonoma:        "2e2b8886c994abb887b1ffad984ed78bda1323eded54bbd4809e8c3a6d48ae45"
    sha256 cellar: :any,                 ventura:       "895087d2591f6e5b2a828370adfcc8615890a09d4638d30ea105822c4590d4f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a71102b55f4d06b91b438222adbdb7dc221fa8b335744773aaece9d671abb527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2109450cd961d89edfdf8b0fce916dd9c5c63a15f52a97c443412a62b2ca8264"
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
