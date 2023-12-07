class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "7178c4833639e6b989ecae73131d02f70735fdb3fc2c7d84bc36c9c3461d93b1"
  license "BSD-2-Clause-Patent"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "230cc85a7d9f84bf4d27572b3440575976b50f9d0b55061f3ad7f6e53a68820d"
    sha256 cellar: :any,                 arm64_ventura:  "76e8cc2dbe88b97c0ae2ee12d8c59c247c876eaa31d16c73225189bed1b37ee2"
    sha256 cellar: :any,                 arm64_monterey: "368c900fbbcf372b6e0817f00109f6359f976d936aeeab6c9dc9e2d6dc6407b6"
    sha256 cellar: :any,                 arm64_big_sur:  "ea7a7559df41e7370133733420f5f8afc39f7e311a5e2f847d7bc7a89df242fa"
    sha256 cellar: :any,                 sonoma:         "c0e45e64bab728cac1eed86307cee8a91e1d83fa68a92b1d081b10cafaa8bcb5"
    sha256 cellar: :any,                 ventura:        "a5f7a09315c5919f4e5291686500a10e0fc70f0d916609262f6ea71d0c4048d1"
    sha256 cellar: :any,                 monterey:       "932d2e01299b5ef5f35401a366d3b5638f89fb8f90ec13135ba34605fc9be6b3"
    sha256 cellar: :any,                 big_sur:        "c23d718b58c09463d996418473d8448864287bab59985a6fc3ee35fa157b3d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2033e78ac571b7705111f3c69c0ee36e33ee05b426b7b63188ee0f217d796992"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "vim" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    Dir.chdir("libvmaf") do
      system "meson", *std_meson_args, "build"
      system "ninja", "-vC", "build"
      system "ninja", "-vC", "build", "install"
    end
    pkgshare.install "model"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libvmaf/libvmaf.h>
      int main() {
        return 0;
      }
    EOS

    flags = [
      "-I#{HOMEBREW_PREFIX}/include/libvmaf",
      "-L#{lib}",
    ]

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
