class Libunwind < Formula
  desc "C API for determining the call-chain of a program"
  homepage "https://www.nongnu.org/libunwind/"
  url "https://github.com/libunwind/libunwind/releases/download/v1.8.2/libunwind-1.8.2.tar.gz"
  sha256 "7f262f1a1224f437ede0f96a6932b582c8f5421ff207c04e3d9504dfa04c8b82"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "a6651b2269e4f2ff7f099b6974ea3815dc7825022be179640973f692559e5cf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "cbb66984b0bb438330bf35650c0039dce1db45a16110dccad8169e0b8add0dfe"
  end

  keg_only "libunwind conflicts with LLVM"

  depends_on :linux
  depends_on "xz"
  depends_on "zlib"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libunwind.h>
      int main() {
        unw_context_t uc;
        unw_getcontext(&uc);
        return 0;
      }
    C
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lunwind", "-o", "test"
    system "./test"
  end
end
