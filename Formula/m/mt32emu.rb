class Mt32emu < Formula
  desc "Multi-platform software synthesiser"
  homepage "https://github.com/munt/munt"
  url "https://github.com/munt/munt/archive/refs/tags/libmt32emu_2_7_1.tar.gz"
  sha256 "e4524d52d6799a4e32a961a2e92074f14adcb2f110a4e7a06bede77050cfdaf4"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^libmt32emu[._-]v?(\d+(?:[._-]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a8ef4049a73f3fb74098b4595392f32c5a3b1f07a0022deeaca01f418a802575"
    sha256 cellar: :any,                 arm64_ventura:  "55d6d8a3e0003491e00839d9ac0969cb6f63e2ea76f4a5192980c472d7a7afe9"
    sha256 cellar: :any,                 arm64_monterey: "063cb312d563870d8e08ab040019873cbb0730562163d5c65e13703f78e3d092"
    sha256 cellar: :any,                 sonoma:         "4ee0954e5580c900cf59984855dfb0acbf44dcd616d40b2afe09b21ebb917f99"
    sha256 cellar: :any,                 ventura:        "b694aa920f746e41fa031a57d0f96190e04afd0bce6ded9581fab5de3c137cce"
    sha256 cellar: :any,                 monterey:       "cbb7f0acda41903fa4328bd108752219626562992a6ceab34029539ee59b2f44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50d34695d4690f75da5d78ae5ee3575b2808b6d0dc3451464d25fb2cfd0d7257"
  end

  depends_on "cmake" => :build
  depends_on "libsamplerate"
  depends_on "libsoxr"

  def install
    system "cmake", "-S", "mt32emu", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"mt32emu-test.c").write <<~EOS
      #include "mt32emu.h"
      #include <stdio.h>
      int main() {
        printf("%s", mt32emu_get_library_version_string());
      }
    EOS

    system ENV.cc, "mt32emu-test.c", "-I#{include}", "-L#{lib}", "-lmt32emu", "-o", "mt32emu-test"
    assert_match version.to_s, shell_output("./mt32emu-test")
  end
end
