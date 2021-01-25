class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/v1.5.3.tar.gz"
  sha256 "440652ae417d88be083ffd9fa5967662172601e31c458a9743f6008d7150c900"
  license "BSD-2-Clause-Patent"

  bottle do
    cellar :any
    rebuild 1
    sha256 "42337edc375b2eaebf63621360edc0bf827c03f2c5f6e07ffe472a65a7603a29" => :big_sur
    sha256 "dbea75752e42a27c01676f942b44110c522c167e482123d0db223f4ea5e94fd3" => :arm64_big_sur
    sha256 "e7b3a833cd602d12291441709a60808e89d6d48c00232fdea155e96fe91911fa" => :catalina
    sha256 "45d4ff0d068b03980d6192e2a636f6ca37fa429fa0c0aecdc8d5d55dcd8b06bd" => :mojave
  end

  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build

  # Upstream patch for Xcode 12, remove in next version
  # https://github.com/Netflix/vmaf/pull/676
  patch do
    url "https://github.com/Netflix/vmaf/commit/b7851292.patch?full_index=1"
    sha256 "686a01b0cc0f6b0e07a12964492e7702ac0b54cc92f5370f1a31d44fd0855ced"
  end

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
