class Mt32emu < Formula
  desc "Multi-platform software synthesiser"
  homepage "https://github.com/munt/munt"
  url "https://github.com/munt/munt/archive/refs/tags/libmt32emu_2_8_5.tar.gz"
  sha256 "801fa771d7384dc462a626d16c8a4d5b9ff73921ff946ea1f042f1a569ee5e11"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://github.com/munt/munt.git", branch: "master"

  livecheck do
    url :stable
    regex(/^libmt32emu[._-]v?(\d+(?:[._-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5fdd6065afa02bee30942c5fdc81f01443f37fe9d34e3b67b18cf9d5168c53bf"
    sha256 cellar: :any, arm64_tahoe:       "b4d6491f1d7414abc1036b3c8ecc0192d6e47ae14983d1e5f24eb5ad615c98b2"
    sha256 cellar: :any, arm64_sequoia:     "7218dca26c5e188ee963b6eb2f815ae294490cde5d6a46c6f47fcbb7405f495e"
    sha256 cellar: :any, arm64_linux:       "f620e8800567ea1a1594fef8d4b39e1d25f42c3050f9d5b05eccbac99ee19224"
    sha256 cellar: :any, x86_64_linux:      "55275c9d842b4eebd48e52d92d24cea9c856cfa65f1a1c6864aa514d1fbf31fc"
  end

  depends_on "cmake" => :build
  depends_on "libsamplerate"
  depends_on "libsoxr"

  deny_network_access!

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
