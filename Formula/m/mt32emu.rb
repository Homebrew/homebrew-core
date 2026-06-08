class Mt32emu < Formula
  desc "Multi-platform software synthesiser"
  homepage "https://github.com/munt/munt"
  url "https://github.com/munt/munt/archive/refs/tags/libmt32emu_2_8_3.tar.gz"
  sha256 "81f8c462f46bc8901618762ae34cf9de93894ff81f41db73c79472fa3baef875"
  license "LGPL-2.1-or-later"
  head "https://github.com/munt/munt.git", branch: "master"

  livecheck do
    url :stable
    regex(/^libmt32emu[._-]v?(\d+(?:[._-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c72627b553abc212c63efd0a279de21cc979bf81880fb96ed2d521c15af0abac"
    sha256 cellar: :any, arm64_sequoia: "a49a518125544c61c8e507c6ffa44c3c6c876dc87dfc6bfa3790cb7a18cf126c"
    sha256 cellar: :any, arm64_sonoma:  "a1788beface4b91d9bb71df403c1e84a6b4ba50a3e475b4862066b3582714312"
    sha256 cellar: :any, sonoma:        "45cc84af934a95c6889140ad2db5559caf324188515c1db135a308ab490b3149"
    sha256 cellar: :any, arm64_linux:   "a3a63d148fc6418f2673dc151cd6f74b2003f1dc9ac0732dbb87dc4451f7906a"
    sha256 cellar: :any, x86_64_linux:  "7df62e1e241f1946bb3a65e27f9c4c582b334d3bdcf90e982abe53979f70e6ce"
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
