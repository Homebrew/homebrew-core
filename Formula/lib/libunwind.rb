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
    sha256 cellar: :any_skip_relocation, arm64_linux:  "74f000df8592676570d4d87170219e605d7839b9349b0c19f780e3c3731a01f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7e7ee2f52ee65cb604d490261817ef728b44938eb0d57d450c5ceb3eda8e302f"
  end

  keg_only "it conflicts with LLVM"

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
