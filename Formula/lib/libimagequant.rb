class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/refs/tags/4.4.0.tar.gz"
  sha256 "22f90ad2ba87fe44d8156862798491bf056034f031a9b8b95d720669047ede20"
  license all_of: ["GPL-3.0-or-later", "HPND"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8784275e2aceca5533694ca52faa75e2694a03f001f965f1035f79a01152dda9"
    sha256 cellar: :any,                 arm64_sonoma:  "867e588a9f65b89a23e681c78b9eeea2790c0295f77869f98893b7cc8a51b8e4"
    sha256 cellar: :any,                 arm64_ventura: "f705e5e5888cb00724316dc2913e6ee50b57e271696b7935d298042ee9d9e98a"
    sha256 cellar: :any,                 sonoma:        "ae9125337223eaf632c9b9505081fb5e17661b1ced908126a7460e80fff87d3e"
    sha256 cellar: :any,                 ventura:       "bd887016de402061c11307ce5cd7dd8f413b8998aab8ec1244258951088dc072"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47e8418707d9b441ad61c1ada6c266bf40ce218907703be292fad76decb08063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "466d5dd7b6128f807b50202517f5c78deb6652fde478e734b3ae99fabd2c45e4"
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
