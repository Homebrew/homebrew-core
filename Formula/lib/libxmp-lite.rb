class LibxmpLite < Formula
  desc "Lite libxmp"
  homepage "https://xmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.6.3/libxmp-lite-4.6.3.tar.gz"
  sha256 "fa6465d8b911363ae602c7baaa625ca1f5223142d10bb4682029c4d2f630cb62"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1881d586305d8979bf1cc1b4c8ddc0bca2196cf9fc1c54f85b4c144badeea3fe"
    sha256 cellar: :any,                 arm64_sequoia: "33f736a998df705e0a4c9cdecbbea17c46ddab5803f97e7834d121079e97b03e"
    sha256 cellar: :any,                 arm64_sonoma:  "ec6e0e00af014526d3f1f96741fb564e724354169f8c9798725c45f174793f50"
    sha256 cellar: :any,                 arm64_ventura: "7d29fddef4290da3d16092ae368fe48e493fd7cab53734986ee72508e404607f"
    sha256 cellar: :any,                 sonoma:        "04ed96a9057040484ce1972869065a2fb281b17a34f987ba0518b49032f8d8af"
    sha256 cellar: :any,                 ventura:       "fb44f2c897a35488b9a0029a4f5df90e2f2943b3f9f3166a4ec4afaf1b079d6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "122f92680e34ed0d76488a405c5e97e1b18280224b2870d1563f1fe6878e3297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b188d2359801030bbd31a68715f74fd271898ea4dd537c3c12def7bdba7b0a5"
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
