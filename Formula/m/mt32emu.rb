class Mt32emu < Formula
  desc "Multi-platform software synthesiser"
  homepage "https://github.com/munt/munt"
  url "https://github.com/munt/munt/archive/refs/tags/libmt32emu_2_7_3.tar.gz"
  sha256 "e51f3475771c9d07116e6cb5ae2e095ef3b11b3107d92c01d3a1dc03be13ff98"
  license "LGPL-2.1-or-later"
  head "https://github.com/munt/munt.git", branch: "master"

  livecheck do
    url :stable
    regex(/^libmt32emu[._-]v?(\d+(?:[._-]\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "51037c0eac2abd5e9470bc021f98ce2eb2034acfd16e381594277e90dd016232"
    sha256 cellar: :any,                 arm64_sequoia: "8d206feb0c19b5817605db0bc65ddc3f158b30839479babdb0d70c29a8c135e1"
    sha256 cellar: :any,                 arm64_sonoma:  "7bce95e4fab2d4f50e12342abf5cfe7b5830f04f14ae93cd585929d23addc831"
    sha256 cellar: :any,                 sonoma:        "a7eed09a0ac9a1337a3421d58ca4bf30ca432c853f460a796044318d03081e37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee5e81dac94185b8566d62f8246d8ac39165ae880f6f8bf96b148b7631cdf11f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a80a2c15efd86451b5cc26db94cae93e7b64157c07449df9c70cb94741db78b5"
  end

  depends_on "cmake" => :build
  depends_on "libsamplerate"
  depends_on "libsoxr"

  # Version fix patch, remove in next release
  patch do
    url "https://github.com/munt/munt/commit/e1d0fb426865ca75e0069c39bbd1b329dee1cb29.patch?full_index=1"
    sha256 "222b22104fb1c7b232a2725dfb7cfa1d107ca831a7d5feac0dff597c7ae8fa49"
  end

  def install
    system "cmake", "-S", "mt32emu", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"mt32emu-test.c").write <<~C
      #include "mt32emu.h"
      #include <stdio.h>
      int main() {
        printf("%s", mt32emu_get_library_version_string());
      }
    C

    system ENV.cc, "mt32emu-test.c", "-I#{include}", "-L#{lib}", "-lmt32emu", "-o", "mt32emu-test"
    assert_match version.to_s, shell_output("./mt32emu-test")
  end
end
