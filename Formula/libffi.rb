class Libffi < Formula
  desc "Portable Foreign Function Interface library"
  homepage "https://sourceware.org/libffi/"
  url "https://sourceware.org/pub/libffi/libffi-3.3.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/libf/libffi/libffi_3.3.orig.tar.gz"
  mirror "https://github.com/libffi/libffi/releases/download/v3.3/libffi-3.3.tar.gz"
  sha256 "72fba7922703ddfa7a028d513ac15a85c8d54c8d67f55fa5a4802885dc652056"
  license "MIT"
  revision 1

  bottle do
    cellar :any
    sha256 "76e28c8fbcddd000f371ce146ee3ca980b7feb54596d649e9309a1edc3225a99" => :big_sur
    sha256 "337709900b0392483dc42c2c3c67ad6e4b9afb0885c7a409deadd2b0129c7c11" => :arm64_big_sur
    sha256 "dd94d39946f53a8f11f78e998f22e46be9666bb265f80bb4714d5d63c1e16a68" => :catalina
    sha256 "d6e5efd7521676dfc58fcba567514b898091c8580df4d6253f5dd40a7ee67c82" => :mojave
    sha256 "7065f0d426921fa069c2494beded9de61e8720954f3f346103c8f871daa4ff8b" => :high_sierra
  end

  head do
    url "https://github.com/atgreen/libffi.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  # Improved aarch64-apple-darwin support. See https://github.com/libffi/libffi/pull/565
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/a4a91e61/libffi/libffi-3.3-arm64.patch"
    sha256 "ee084f76f69df29ed0fa1bc8957052cadc3bbd8cd11ce13b81ea80323f9cb4a3"
  end

  def install
    args = std_configure_args

    on_macos do
      # This can be removed in the future when libffi properly detects the CPU on ARM.
      # https://github.com/libffi/libffi/issues/571#issuecomment-655223391
      args << "--build=aarch64-apple-darwin#{OS.kernel_version}" if Hardware::CPU.arm?
    end

    system "./autogen.sh" if build.head?
    system "./configure", *args
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
