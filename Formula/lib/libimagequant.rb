class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/4.2.0.tar.gz"
  sha256 "716ffb2bc1594a4f9af324d7096129a37a3f9ebcee7f78a132282fbf2cf22fd8"
  license :cannot_represent

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "97c3688ef5aa75bd33d85e823137164e9d466d42e13c18f728ce80f07b00b657"
    sha256 cellar: :any,                 arm64_monterey: "d63de9dcc545248c6be1ad3995599096796f489e59757af007311f0c3aeb98a8"
    sha256 cellar: :any,                 arm64_big_sur:  "9416c5c53269072776255fb2abc2ecc1548463a09231de0e008cf922a1ead3e7"
    sha256 cellar: :any,                 ventura:        "544e83a1484121ac15453559cdc1298fbbef378c6cc5e928edd3f244276be27a"
    sha256 cellar: :any,                 monterey:       "8f5280c3f6d139f3ed0cb6d7adb4b21ca467f3aa971d5889f279a3c8dd689d8f"
    sha256 cellar: :any,                 big_sur:        "d1ad32221e27f3c2035a3acf1adbb078de190984dc1580e188a518bad6d013ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6c743a999b18e55734d0dda08dcde833b87843ba7c37dadf5e63f6390d422b9"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  def install
    cd "imagequant-sys" do
      system "cargo", "cinstall", "--prefix", prefix
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
