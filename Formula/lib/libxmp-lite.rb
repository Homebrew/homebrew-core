class LibxmpLite < Formula
  desc "Lite libxmp"
  homepage "https://xmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.7.2/libxmp-lite-4.7.2.tar.gz"
  sha256 "bace7f53248a2cd5adcf77f9402a8858fc0fec05f4e6d6436e3d2a28d68f640e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "69a587fda4a04a06dfed5e026f14f48bcb91275bdf5b4d18ff97514f30d6574e"
    sha256 cellar: :any, arm64_sequoia: "5f3d1a92d9d63b5936ea5fd3b1138ef561f4ee586ff88ec5fd4541082f15dce3"
    sha256 cellar: :any, arm64_sonoma:  "65ddf29ef96c71813f80fc94bcd3695e171598a4e67a71bc02eca5ece323699d"
    sha256 cellar: :any, sonoma:        "792dfd93e728b4a401c52be678a2601dc7c3afdff668286e96204691997f14d6"
    sha256 cellar: :any, arm64_linux:   "23d04f6793275f054d3b287ab161fbe50ee5099c95e3c8fa04300ba996a13ade"
    sha256 cellar: :any, x86_64_linux:  "7dab9c9bd74dd37bfafba15146c3a9475fb7d53357e0f0e31d782a7942b5681c"
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
