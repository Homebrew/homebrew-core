class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/refs/tags/4.4.1.tar.gz"
  sha256 "2464a3e922b5a220b633d674062b82f0670114f8f3dd30d1935a621c95965f1b"
  license all_of: ["GPL-3.0-or-later", "HPND"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9fe68c59c0500f834deced30fcd58c965148988f238d51791d39c6c284d71684"
    sha256 cellar: :any,                 arm64_sequoia: "35636b9bf13cd99e77dec879e87736122925c790fec18da07dbcbea76083bdc6"
    sha256 cellar: :any,                 arm64_sonoma:  "f1cfb5f5fb3e31907edf925d0df58be68d53fd4241fb819e946aba322cda4375"
    sha256 cellar: :any,                 sonoma:        "8a25e968794937adcb94e84e2421a0b8fd48503205451fcc24ddd41ed84ad8be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0884471a064070eb8209c726fbb5e2068c6dcc4a3f2f74b6fb0e69b4117e51e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9943e809de898982fbd65821564d201a4f88d0d902d504d2b8f4a059ab9c94c"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  def install
    cd "imagequant-sys" do
      system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--release", "--prefix", prefix, "--libdir", lib
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libimagequant.h>

      int main()
      {
        liq_attr *attr = liq_attr_create();
        if (!attr) {
          return 1;
        } else {
          liq_attr_destroy(attr);
          return 0;
        }
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-limagequant", "-o", "test"
    system "./test"
  end
end
