class Pixman < Formula
  desc "Low-level library for pixel manipulation"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/pixman-0.42.2.tar.gz"
  sha256 "ea1480efada2fd948bc75366f7c349e1c96d3297d09a3fe62626e38e234a625e"
  license "MIT"

  livecheck do
    url "https://cairographics.org/releases/?C=M&O=D"
    regex(/href=.*?pixman[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f98b74948d7fa6edc00158c63c02de8f9c58276efb076ab1d6e740ef061f8dee"
    sha256 cellar: :any,                 arm64_monterey: "1e4026e8980666338f1a49cc61a3b6e968a744d92a67aeacfe918f8e8266d8ce"
    sha256 cellar: :any,                 arm64_big_sur:  "0a8a93bd44aca5367c4b4dc81241899adadd9429b6bab11e672bd33ff4dbed3f"
    sha256 cellar: :any,                 ventura:        "701df7463b3e0cf00f27fb766a5f73d80380d06c7c5c9a7d2a6b0b4dbc137c17"
    sha256 cellar: :any,                 monterey:       "f7c0d1f71dd2dae2ab48c6d50ca713f3b7a41d74289b41bc4935909e7e533c2c"
    sha256 cellar: :any,                 big_sur:        "14c70823204f964a81befaf5432b3815be7f5768b54cb93a0382b94d44e033b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "032c9f7eccbac1359a97f55f732a98eaac784d3413ab0b0dc90606012ef3f657"
  end

  depends_on "pkg-config" => :build

  def install
    args = ["--disable-gtk", "--disable-silent-rules"]
    # Disable NEON intrinsic support on macOS
    # Issue ref: https://gitlab.freedesktop.org/pixman/pixman/-/issues/59
    # Issue ref: https://gitlab.freedesktop.org/pixman/pixman/-/issues/69
    args << "--disable-arm-a64-neon" if OS.mac?

    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <pixman.h>

      int main(int argc, char *argv[])
      {
        pixman_color_t white = { 0xffff, 0xffff, 0xffff, 0xffff };
        pixman_image_t *image = pixman_image_create_solid_fill(&white);
        pixman_image_unref(image);
        return 0;
      }
    EOS
    flags = %W[
      -I#{include}/pixman-1
      -L#{lib}
      -lpixman-1
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
