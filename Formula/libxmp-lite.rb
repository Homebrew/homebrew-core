class LibxmpLite < Formula
  desc "Lite libxmp"
  homepage "https://xmp.sourceforge.io"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.5.0/libxmp-lite-4.5.0.tar.gz"
  sha256 "19a019abd5a3ddf449cd20ca52cfe18970f6ab28abdffdd54cff563981a943bb"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_monterey: "026c3cdd675caf62652f8f2a1c5c4b6183565d1ac9bc0aa8f439926e496fa865"
    sha256 cellar: :any, arm64_big_sur:  "3e5ad6d3a6c5e8f8e78055aa92d7b92bcc28faf2ae4904154b28d8d5cc83426e"
    sha256 cellar: :any, monterey:       "ecd2af08822aa07e9b7a2a3b872a368979de55b8d359a22fbd6f4826175e24d2"
    sha256 cellar: :any, big_sur:        "da41c0decc2231fc35a884c1bfa61240261958e6cde77d863c3d62dd34830d5f"
    sha256 cellar: :any, catalina:       "2fd028d14695096bcb8fb8839758fb962c36d3edfd83e959a652bd735d4684b4"
    sha256 cellar: :any, mojave:         "457442a50a49ab9267dfa586d7abeb3e3bebcdf1860a0d9ee0d0b34e341bf71a"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <stdio.h>
      #include <libxmp-lite/xmp.h>

      int main(int argc, char* argv[]){
        printf("libxmp-lite %s/%c%u\n", XMP_VERSION, *xmp_version, xmp_vercode);
        return 0;
      }
    EOS

    system ENV.cc, "-I", include, "-L", lib, "-L#{lib}", "-lxmp-lite", "test.c", "-o", "test"
    system "#{testpath}/test"
  end
end
