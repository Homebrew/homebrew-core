class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/v2.1.1.tar.gz"
  sha256 "e7fc00ae1322a7eccfcf6d4f1cdf9c67eec8058709887c8c6c3795c617326f77"
  license "BSD-2-Clause-Patent"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "dbea75752e42a27c01676f942b44110c522c167e482123d0db223f4ea5e94fd3"
    sha256 cellar: :any, big_sur:       "42337edc375b2eaebf63621360edc0bf827c03f2c5f6e07ffe472a65a7603a29"
    sha256 cellar: :any, catalina:      "e7b3a833cd602d12291441709a60808e89d6d48c00232fdea155e96fe91911fa"
    sha256 cellar: :any, mojave:        "45d4ff0d068b03980d6192e2a636f6ca37fa429fa0c0aecdc8d5d55dcd8b06bd"
  end

  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build

  def install
    Dir.chdir("libvmaf") do
      system "meson", *std_meson_args, "build"
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
