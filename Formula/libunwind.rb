class Libunwind < Formula
  desc "C API for determining the call-chain of a program"
  homepage "https://www.nongnu.org/libunwind/"
  url "https://download.savannah.nongnu.org/releases/libunwind/libunwind-1.5.0.tar.gz"
  sha256 "90337653d92d4a13de590781371c604f9031cdb50520366aa1e3a91e1efb1017"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "01d88381315b99c187e8351a10764ff2e38872bd178fe51bf3ddedba3d6418ee"
  end

  depends_on :linux

  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"

    # Rename `libunwind.a` to avoid conflict with LLVM's `libunwind.a`
    mv lib/"libunwind.a", lib/"libunwind-standalone.a"
  end

  def caveats
    <<~EOS
      To avoid conflicts with LLVM, `libunwind.a` has been installed as `libunwind-standalone.a`.
    EOS
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libunwind.h>
      int main() {
        unw_context_t uc;
        unw_getcontext(&uc);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lunwind", "-o", "test"
    system "./test"
  end
end
