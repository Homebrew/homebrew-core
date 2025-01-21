class LibxmpLite < Formula
  desc "Lite libxmp"
  homepage "https://xmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.6.1/libxmp-lite-4.6.1.tar.gz"
  sha256 "d2096d0ad04d90556a88856a3a9e093d434ed3b6b6791907be73db7e2b9b7837"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "45f2bf9d9951767cf6b3432907a7d78c4e64ad758b28bd691f763446ee84eeb1"
    sha256 cellar: :any,                 arm64_sonoma:  "04a21a3c396232c2ab897af6d7becbfd7e983e53f230082cf7852f2cdc76956a"
    sha256 cellar: :any,                 arm64_ventura: "3e1bc29593bab4b7cfc75fa8127468f79e04f2664abe204b246c029b02b5acea"
    sha256 cellar: :any,                 sonoma:        "cfb0b254511b6c25751c6ba6ba0af28ac18e8bfc7d5b14aa2a1794199d06098d"
    sha256 cellar: :any,                 ventura:       "f82931dcaf8023784413cf966e64085f0d31083e25b39296bbd36cf3fe5d9fea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "422e9bdeaf10af4d9b4d587653ad89aa5cf2e4fedd7d7ee2581b0f899982af7d"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <libxmp-lite/xmp.h>

      int main(int argc, char* argv[]){
        printf("libxmp-lite %s/%c%u\\n", XMP_VERSION, *xmp_version, xmp_vercode);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxmp-lite", "-o", "test"
    system "./test"
  end
end
