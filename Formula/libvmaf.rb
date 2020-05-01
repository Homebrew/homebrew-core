class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/v1.5.1.tar.gz"
  sha256 "9267b40223ac8d67fb6b99726ce7ed3925b9843f18ad5aa8ffbe2fe873e45cbe"

  bottle do
    cellar :any
    sha256 "873889277a7832ad4a824fc11de7a8e83a07dce4e875b91b3ea17fa1240dabca" => :catalina
    sha256 "e443f171f8b387448750dafaf145d8fd03ded30e5ef92e6774c3ccef33d3c53e" => :mojave
    sha256 "b8bf0a9899818a59cb23ed9fe7abd84f84418cf340685efea16618795e5b731b" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    Dir.chdir("libvmaf") do
      system "meson", *std_meson_args, "build", "--buildtype", "release"
      system "ninja", "-vC", "build"
      system "ninja", "-vC", "build", "install"
    end
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
