class LibxmpLite < Formula
  desc "Lite libxmp"
  homepage "https://xmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.7.3/libxmp-lite-4.7.3.tar.gz"
  sha256 "e199da3f7552f5ac688a091b8d28ea3c9ffd2beb845d15aac17d4d264f851d71"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4065b670e30b968e6c74f55ec40c53840a1faa5ff08757c3882e6ae63be3a2ce"
    sha256 cellar: :any, arm64_tahoe:       "7eadd2ffcc5e9134db68b10c1fddaa303a57d093df93eea6c687c5985a38389d"
    sha256 cellar: :any, arm64_sequoia:     "2c77acf76acd29dc96d15b5aef46ec1280684b7cc2029b58e8717fed046846ce"
    sha256 cellar: :any, arm64_linux:       "6f17f36ff7f65aacc723623d33abf1740823315838531dc81964a2a0401d2faa"
    sha256 cellar: :any, x86_64_linux:      "bda8a5d95767c7e4397ca6e69469adde1da64b2f7a0b9e3d00ea5eb0ef4ecf9d"
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
