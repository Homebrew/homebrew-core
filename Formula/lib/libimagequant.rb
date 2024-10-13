class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/refs/tags/4.3.3.tar.gz"
  sha256 "c50a59003a4c4ce53c76314e62f1e86d86d882bc09addb13daa0faa9260b9614"
  license all_of: ["GPL-3.0-or-later", "HPND"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "f411bdf39fe60ea4ed53aecdd492797922f06b0689bb04c3f02052af55a18d35"
    sha256 cellar: :any,                 arm64_sonoma:   "979e2b7ba7184cfa5c8f7f6c6f49ac20483c319421ea0de84e64846683635d5f"
    sha256 cellar: :any,                 arm64_ventura:  "aa15ba471418f6a856f757c0bd1a5cec72a395dd6165fb047de74a2cb49e1762"
    sha256 cellar: :any,                 arm64_monterey: "b992cfca22175166db0ff267ad0b1e8e45302670abb24c6766e1ca397239965f"
    sha256 cellar: :any,                 sonoma:         "c7abdc523621e1b109df3441e62897806e25adf78d5a8ad6458102a9d1d8b2f1"
    sha256 cellar: :any,                 ventura:        "a73a58ebbfe42f237b93273f9a00b6a074cb98fa44ddd5bc7709531108ab8d47"
    sha256 cellar: :any,                 monterey:       "dab7441d58d0073025823ae1925c5aa10cd14258f0d134b0fdff4d6f5f7fa6d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6c9141dc8c392d162db72c6038c546e7ea82194c517a948ce3c6c43b40ddfe1"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  def install
    cd "imagequant-sys" do
      system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--release", "--prefix", prefix, "--libdir", lib
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-limagequant", "-o", "test"
    system "./test"
  end
end
