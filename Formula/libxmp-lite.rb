class LibxmpLite < Formula
  desc "Lite libxmp"
  homepage "https://xmp.sourceforge.io"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.5.0/libxmp-lite-4.5.0.tar.gz"
  sha256 "19a019abd5a3ddf449cd20ca52cfe18970f6ab28abdffdd54cff563981a943bb"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c0529347eb14021e29716dc96c5d275efa984fb5aa2394dd116547342878e6ed"
    sha256 cellar: :any, big_sur:       "8fd127bc9b8ddefedf784c9387b9b901a70917b600ce5f4e4087d0abbba530d1"
    sha256 cellar: :any, catalina:      "a155be151ab2b536aae7aa7cb44999b8e1dc5a210b06af6f18265eb4037fd6ab"
    sha256 cellar: :any, mojave:        "d1956ebfe2812cededb97f6717925f21ca1a71dbd8b4211792369cb0a9f3c74f"
    sha256 cellar: :any, high_sierra:   "e0b20b3d4fcd64e4c90b9d704ee5621739bf633bdf8bd71bd1b2cb713a2b0284"
    sha256 cellar: :any, sierra:        "d1ed5c1803f622508c3e20bb9c48f9bc644d0d639574aaa298724dd0aa17262d"
    sha256 cellar: :any, el_capitan:    "a8fcd7a5ab446a221b7444b90191656175f6060a0730a703e4f862c4f49690f4"
    sha256 cellar: :any, yosemite:      "448d0a4bcd651c44551a1d3785de1c0181cce1ee374cd7903a629cb200a3011d"
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
