class Libunwind < Formula
  desc "C API for determining the call-chain of a program"
  homepage "https://www.nongnu.org/libunwind/"
  url "https://download.savannah.nongnu.org/releases/libunwind/libunwind-1.5.0.tar.gz"
  sha256 "90337653d92d4a13de590781371c604f9031cdb50520366aa1e3a91e1efb1017"
  license "MIT"

  livecheck do
    url "https://download.savannah.nongnu.org/releases/libunwind/"
    regex(/href=.*?libunwind[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, x86_64_linux: "0dbcc161bfb5d2e20743f2bfcbf2fcf0e5583662f91d6c2ab4b0e0bea2e26a1d"
  end

  keg_only "libunwind conflicts with LLVM"

  depends_on :linux

  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
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
