class Mt32emu < Formula
  desc "Multi-platform software synthesiser"
  homepage "https://github.com/munt/munt"
  url "https://github.com/munt/munt/archive/refs/tags/libmt32emu_2_6_3.tar.gz"
  sha256 "a24ee0a8ae9aa4138ffb185f123768b23fbb8b5b3bebb07882f3ba2836ed4905"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^libmt32emu[._-]v?(\d+(?:[._-]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2e43d3a5545974b9ea767af9d457201d415eb2b22ed26250d67ba2957e7ded97"
    sha256 cellar: :any,                 arm64_big_sur:  "09f6635670c01037fbbc2f7574a59a86593663e6a4f0ed85203bf9892eb19f26"
    sha256 cellar: :any,                 monterey:       "c3ceb3d87a750e0188b8b3bd0b8f829bed0741a902b98de68417fea132821b7c"
    sha256 cellar: :any,                 big_sur:        "bcc75284966fafef26c9e2ae60822bb29228e7ad375293bd4e0184818bacc457"
    sha256 cellar: :any,                 catalina:       "dfaed0067cbe20314db565af0c8e70972170f51c9a0d40718e3f3055a189242d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a81eefd6f3e95094fb06a2dd91d141c4541657fe1036621c8abb44f4b0e262a0"
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
