class Mt32emu < Formula
  desc "Multi-platform software synthesiser"
  homepage "https://github.com/munt/munt"
  url "https://github.com/munt/munt/archive/refs/tags/libmt32emu_2_8_6.tar.gz"
  sha256 "9d351ccc4671027bdaf62ddc08aafdec8971ecb61835d9324bce949916cb0775"
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
    sha256 cellar: :any, arm64_golden_gate: "dc6558c0fa7a50037252e9e702ab3da1e6d7bea349c3f6862831ac7eb93c0038"
    sha256 cellar: :any, arm64_tahoe:       "9331d8b6c89d41c2134a29a06e4e037822288952f2d1880ac42f066d338df89f"
    sha256 cellar: :any, arm64_sequoia:     "37eab2ccf702b957b92e2e6b03c8ee87d7ec361ed8754d4043edbdc99849063e"
    sha256 cellar: :any, arm64_linux:       "6cf529d43744cfbf17e10811eb66bd15602bb79e9e3f84b6b11b42944d65d3e6"
    sha256 cellar: :any, x86_64_linux:      "91ba1d484e04c625a402024d97eaa639fd3b462dd9912f0873a78603e158aa6c"
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
