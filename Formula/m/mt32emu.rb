class Mt32emu < Formula
  desc "Multi-platform software synthesiser"
  homepage "https://github.com/munt/munt"
  url "https://github.com/munt/munt/archive/refs/tags/libmt32emu_2_7_2.tar.gz"
  sha256 "3b0beff64e83d2b4879baba2326eed1300edc9663b3dc52621fc74d196ca9a80"
  license "LGPL-2.1-or-later"
  head "https://github.com/munt/munt.git", branch: "master"

  livecheck do
    url :stable
    regex(/^libmt32emu[._-]v?(\d+(?:[._-]\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6471e62d5707fb60db08ef8ec9cd104ebf428331f8209f1e3c03634cebefb0c5"
    sha256 cellar: :any,                 arm64_sequoia: "7dedf906d2b598cf6a058f35544c300d6ceb3a12af1388d1b599c0054592ad02"
    sha256 cellar: :any,                 arm64_sonoma:  "a0c2c0dc6418dadcbff63677f77ab64e6ccdf244c9671edecf9642f288c72c64"
    sha256 cellar: :any,                 arm64_ventura: "b5370efcc40c5a7d40370fb26831fa33d1614df0236b9e2a11e5e72b2a1c3008"
    sha256 cellar: :any,                 sonoma:        "6d39796b131f4a1fd585274e136c5124905bb3184021754900eacb31c01712cc"
    sha256 cellar: :any,                 ventura:       "86efe1414cb2caaf791ecf4f1889595f202e3d337718ef172a1d76736bdf3dfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c82f0846ac879c75313e981f1824955027fad8a4c5a7a4dfbabd73097b7bbdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a0f9273063bb82683ba95993f2ece66a662d410028c564196d54e9900fc4897"
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
