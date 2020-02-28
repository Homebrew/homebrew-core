class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/v1.5.1.tar.gz"
  sha256 "9267b40223ac8d67fb6b99726ce7ed3925b9843f18ad5aa8ffbe2fe873e45cbe"

  bottle do
    cellar :any_skip_relocation
    sha256 "298df152c1e9d939df2fa6637113a77f76b2df91e77f4e9e8e190a45186c306c" => :catalina
    sha256 "1a11bb8c22c5ffbf56f2963c2cfc82dd4ff9615595d5f870dc4f005dbd323e7b" => :mojave
    sha256 "2480b6f5f5ff58acf9d1c732db8b2a04e408d082a53590bdad15d203e02aa791" => :high_sierra
    sha256 "c5b2cbf13a844a4591e2f1dbf7d20266715130802ba3b030f45e9471da994e86" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    Dir.chdir("libvmaf") do
      system "meson", "--prefix=#{prefix}", "build", "--buildtype", "release"
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
