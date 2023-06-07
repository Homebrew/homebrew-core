class Mt32emu < Formula
  desc "Multi-platform software synthesiser"
  homepage "https://github.com/munt/munt"
  url "https://github.com/munt/munt/archive/refs/tags/libmt32emu_2_7_0.tar.gz"
  sha256 "5ede7c3d28a3bb0d9e637935b8b96484fadb409c9e5952a9e5432b3e05e5dbc1"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^libmt32emu[._-]v?(\d+(?:[._-]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e17f59e16d6e854e33f00f336878f222a8526600468507a4b9f9be0eed8f22c6"
    sha256 cellar: :any,                 arm64_monterey: "b687a8634f4a6b1e75589c41cd6e053452506e48be916360046ff79ef5b374a9"
    sha256 cellar: :any,                 arm64_big_sur:  "9d119e757d88a8fd84c127b1d3f875f4ad72c3f9ea99973b5a485194651b3bcd"
    sha256 cellar: :any,                 ventura:        "3c4726017584143d94e3a89198f9ca27e08353a98fca6b83b68d396269458fcf"
    sha256 cellar: :any,                 monterey:       "b0449f67f14ff75ad4c8ddd8d5f81f989e5ffe61261b12a2fe87ca48aeed649a"
    sha256 cellar: :any,                 big_sur:        "3c414eefe4494914e24b36ab00aeec61c6520202101b74ef2f3e41e60aaad2f9"
    sha256 cellar: :any,                 catalina:       "fd89bfb84134e333c40f3e819b997423ca1538a9e5f40c8a9f377454c729ab99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "929ee5e13b8e418b03d75cb0a9855b9fe6cf509739575b1405618de1695fcb96"
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
