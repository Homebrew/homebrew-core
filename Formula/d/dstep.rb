class Dstep < Formula
  desc "Tool for converting C and Objective-C headers to D modules"
  homepage "https://github.com/jacob-carlborg/dstep"
  url "https://github.com/jacob-carlborg/dstep/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "b89c9f7b9f4ed0e594b9e8624f4d90f0dbace43ddc4da00e2554733f015b75d9"
  license "BSL-1.0"

  depends_on "dub" => :build
  depends_on "ldc"
  depends_on "llvm@18"

  def install
    system "./configure", "--llvm-path", Formula["llvm@18"].opt_prefix
    system "dub", "build", "--build=release"
    bin.install "bin/dstep"
  end

  test do
    (testpath/"test.h").write <<~EOS
      int main();
    EOS
    system bin/"dstep", "test.h", "-o", "test.d"
    assert_match "extern (C)", (testpath/"test.d").read
  end
end
