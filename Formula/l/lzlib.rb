class Lzlib < Formula
  desc "Data compression library"
  homepage "https://www.nongnu.org/lzip/lzlib.html"
  url "https://download.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.14.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/lzlib/lzlib-1.14.tar.gz"
  sha256 "5acac8714ed4f306020bae660dddce706e5f8a795863679037da9fe6bf4dcf6f"
  license "BSD-2-Clause"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/lzlib/"
    regex(/href=.*?lzlib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e93a03a440d76fd50bb8d94cfa7ef964733bf4c0aa26cf36306131f41a233f21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cda6502902573c519aa6566a38a959550410e78b1236ca467034e4674293fef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0afd75f6862c9ce55adaf597ac84ed35be36b1c2ab76496a7c6fceab4c6e454"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92e5f7aa8732c745c1cc5bd41540aeff2fcb3538a9eb4a3060c82ff33d332067"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8d0900437ef2ad17670cca583ec6d4af7de4fa1ffc2b7f512003c8119cb2758"
    sha256 cellar: :any_skip_relocation, ventura:        "ff40c9e1befa241ea0f7a8dfd6e70b38bd2aefec401711918c7ca6841843f9eb"
    sha256 cellar: :any_skip_relocation, monterey:       "c12c6a4c2ae56509b37c328d8e250653f773d3f653300b697a566fdc3ff3e106"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09466159276ad817d43408f241735eea133b11e7dbaa46533132818d5e2a034a"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "CC=#{ENV.cc}",
                          "CFLAGS=#{ENV.cflags}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdint.h>
      #include "lzlib.h"
      int main (void) {
        printf ("%s", LZ_version());
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-llz",
                   "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
