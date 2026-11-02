class Mt32emu < Formula
  desc "Multi-platform software synthesiser"
  homepage "https://github.com/munt/munt"
  url "https://github.com/munt/munt/archive/refs/tags/libmt32emu_2_8_4.tar.gz"
  sha256 "1080ee41fe1f9a2d9abc7ec010cb105a57576528708e3d0ef467b6a7d7fde92f"
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
    sha256 cellar: :any, arm64_golden_gate: "e768a3fd9308c5d9de58cc5c2d5562a154a97a65b4d936cd11711763b3dac983"
    sha256 cellar: :any, arm64_tahoe:       "fef2bb7f6fd9329ea64579bfb16b9c38a793dc33cfc902c21758ab6b27becf35"
    sha256 cellar: :any, arm64_sequoia:     "47f27472f2fb6c33054fd7ca9a754779177254e71cb25602deed5df01cda09f6"
    sha256 cellar: :any, arm64_linux:       "b32b1f3b812d94cb8e73c64ef45c89a0afaa2cea40c4925f015f12e47b499284"
    sha256 cellar: :any, x86_64_linux:      "8b56f514854749a0c571cb050694fdd3964533a30837182cf37f509a7a6963f7"
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
