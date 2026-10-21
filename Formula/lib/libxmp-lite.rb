class LibxmpLite < Formula
  desc "Lite libxmp"
  homepage "https://xmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.7.4/libxmp-lite-4.7.4.tar.gz"
  sha256 "d4b6108b6e8c7ecc106403bc4bab28fb46686867a7b5247567371ad557634c12"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5d04a6e0fd381f5fcfc00ba9a948ee7daeb66330081eb3078945a92c749d4054"
    sha256 cellar: :any, arm64_tahoe:       "15856a8ed1651eb79386889ca0320d7f191a7a5bfff5864fa66f79674a53d3d6"
    sha256 cellar: :any, arm64_sequoia:     "11b31446f7870e3d525f13308d30ee468d92fe451f3d6e6be468e8d8ae8cf0ea"
    sha256 cellar: :any, arm64_linux:       "981228ea2ed0d3649add7c7e5248af7242f36f022d60a167e9f40d258430b879"
    sha256 cellar: :any, x86_64_linux:      "aaa7543a5fd3e96675a2ce2f1d488936e6f7cc6a5e4568a4e80942751fbd396a"
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
