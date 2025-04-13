class LibxmpLite < Formula
  desc "Lite libxmp"
  homepage "https://xmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.6.2/libxmp-lite-4.6.2.tar.gz"
  sha256 "f4d03ea076c4beecd1c834d07cf7adadb6e680ae45dcc9cf8aff279c4748d003"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2e2091326691e6f0279ca6338598108e450081a3a0aaab6156bd19fd59d4bd36"
    sha256 cellar: :any,                 arm64_sonoma:  "beae63567964648910ba8d03b52884ce2b3acfd1617083459b33fad2a18738b7"
    sha256 cellar: :any,                 arm64_ventura: "3adcb85150babc53ba6c3a78a109515fbde4e97891606c629e3f6de81b688c56"
    sha256 cellar: :any,                 sonoma:        "83edec8369c8897c694717b3d7d6d24bf07757e6c1fb9337ec2671f770b8ec5e"
    sha256 cellar: :any,                 ventura:       "befdc733f863ccf59f13a7735514c87e4cbbd68a8f33ac46d6cc0ea2c0a6c4c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c7649711ff0d41f54b9e91ccdc51a5b49b9d8c17d3d311e4abc0da5657a4e55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b494f34f5a002db0090ed95c00445921d774b8d757e3b72caf26cf79abd5f7d4"
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
