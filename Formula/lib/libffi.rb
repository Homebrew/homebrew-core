class Libffi < Formula
  desc "Portable Foreign Function Interface library"
  homepage "https://sourceware.org/libffi/"
  url "https://github.com/libffi/libffi/releases/download/v3.4.5/libffi-3.4.5.tar.gz"
  sha256 "96fff4e589e3b239d888d9aa44b3ff30693c2ba1617f953925a70ddebcc102b2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "05b449dea2ce5e3f9d0a68557ab04938dc95c179bd33797e8b455efab7861241"
    sha256 cellar: :any,                 arm64_ventura:  "c1f444ded62e9fc4da1179f2f1f18bbf3db6be8d8e3b764f52d3370a6a534ed3"
    sha256 cellar: :any,                 arm64_monterey: "971cbcb1d220e448683bbc76c561e03e41610a8ce4065b9be92e2e7e838c4a07"
    sha256 cellar: :any,                 sonoma:         "70c125b86120c56b00f737b46f207da0b46d54233367d36d53ea774562e39c18"
    sha256 cellar: :any,                 ventura:        "4aff209ef6d0aadd8dbc6384deb2cb1173bed527e27838142ab2c5b93a647e76"
    sha256 cellar: :any,                 monterey:       "7c96a49210ba55ce4473d36c2dbd86192ae33f2c267ee47b5ed0e970aea62093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad76b74572cf5792f5160938bd6ae8b934f0d021abd300d45feba51dca1313fc"
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

    flags = ["-L#{lib}", "-lffi", "-I#{include}"]
    system ENV.cc, "-o", "closure", "closure.c", *(flags + ENV.cflags.to_s.split)
    system "./closure"
  end
end
