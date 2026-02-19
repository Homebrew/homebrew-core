class Libunwind < Formula
  desc "C API for determining the call-chain of a program"
  homepage "https://www.nongnu.org/libunwind/"
  url "https://github.com/libunwind/libunwind/releases/download/v1.8.3/libunwind-1.8.3.tar.gz"
  sha256 "be30d910e67f58d82e753231f1357f326a1a088acf126b21ff77e60aab19b90b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c36c1cbc4e8cc6072c609ecc76f2fd8546dad4e1cebe8d41cd69984dcba2babb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "87c11a5130ea0663cb9e9b007d734470522501d25591b2a7f58034376f7aa3bb"
  end

  keg_only "it conflicts with LLVM"

  depends_on :linux
  depends_on "xz"
  depends_on "zlib-ng-compat"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
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
