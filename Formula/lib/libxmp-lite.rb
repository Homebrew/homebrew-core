class LibxmpLite < Formula
  desc "Lite libxmp"
  homepage "https://xmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.7.1/libxmp-lite-4.7.1.tar.gz"
  sha256 "e5dcd937a931650047a01b7c6cebbb513f3c0e2182dd61f4801181771ccbcd97"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a79650a4aace0af5d29b0b0959934dfd3055df39a87545817e8276d26722babd"
    sha256 cellar: :any, arm64_sequoia: "23978535137abc912ec7261e3a12825ba29b3aaf0d036a05b3ef5cd5a55dffc4"
    sha256 cellar: :any, arm64_sonoma:  "72379c6f45f9f5ac37fe6ed4c36bca2964773d5821d89b3debcb03cd51c04eed"
    sha256 cellar: :any, sonoma:        "66954f96fe01d5ed65c5f1416889c02008fae82d45e552dc4aa975ae3641c98e"
    sha256 cellar: :any, arm64_linux:   "6f4225d1989261d6dd238c0362e7a3414657f2317ae43089e08b13d28e318f12"
    sha256 cellar: :any, x86_64_linux:  "901b45722006892a2e6ad15f7132c3fe4d28c2f1518f8829e9c119d8ce68f5d1"
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
