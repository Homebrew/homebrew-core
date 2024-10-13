class LibxmpLite < Formula
  desc "Lite libxmp"
  homepage "https://xmp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xmp/libxmp/4.6.0/libxmp-lite-4.6.0.tar.gz"
  sha256 "71a93eb0119824bcc56eca95db154d1cdf30304b33d89a4732de6fef8a2c6f38"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "c45fbdc96da10e952e39b5b1cb2893f4f3e466dcf09ff85e6c0c7b13697ffa34"
    sha256 cellar: :any,                 arm64_sonoma:   "f26e1ba3917347f6a7a258c0dae899801b702c4dac38732b92bd7f0df92813fc"
    sha256 cellar: :any,                 arm64_ventura:  "9500723abc3c75d1b85b4673344bf7ef874a6374883042fc8ec9cfe5f8064412"
    sha256 cellar: :any,                 arm64_monterey: "fcfcc41e351cc97fc54a8c47fc958ac4c140fcfca85efbe4dc59d6c4768dc4e0"
    sha256 cellar: :any,                 arm64_big_sur:  "6569f2687511dbc55c47854deda2bacac26e6e27b431da225b508814c720500e"
    sha256 cellar: :any,                 sonoma:         "64a236751b18526082594d9cf8df3073b63f3e62476243a615aa802fee0fe0e5"
    sha256 cellar: :any,                 ventura:        "7f9ac879b3cd5e9b67cac75a79c5f25b53165986444edcefaf8149f1c0f00c33"
    sha256 cellar: :any,                 monterey:       "165bc02b01f381bd122b421490245ade0b277d4e0051dc4498b8354edb811488"
    sha256 cellar: :any,                 big_sur:        "56c37651e4a234b8796895786eccc4aacc03eb22c8aa3d30e16598856c4462a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cf6c9f842c6d2c80e98c6731e0707ea6f9c8ac9b89dc8c3b5a1d396d81ce46c"
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

    system ENV.cc, "test.c", "-I", include, "-L", lib, "-L#{lib}", "-lxmp-lite", "-o", "test"
    system "#{testpath}/test"
  end
end
