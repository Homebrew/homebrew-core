class Capstone < Formula
  desc "Multi-platform, multi-architecture disassembly framework"
  homepage "https://www.capstone-engine.org/"
  url "https://github.com/capstone-engine/capstone/archive/refs/tags/5.0.7.tar.gz"
  sha256 "6427a724726d161d1e05fb49fff8cd0064f67836c04ffca3c11d6d859e719caa"
  license "BSD-3-Clause"
  head "https://github.com/capstone-engine/capstone.git", branch: "next"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "921a27cf982706500e7e16c12cc5ae870c24d81e777da7c148b8567a49a72e76"
    sha256 cellar: :any,                 arm64_sequoia: "ab8960a1668a44a537f3056943fb72b8f7753345f2ac4668edd5e3c2e3d94eaa"
    sha256 cellar: :any,                 arm64_sonoma:  "3631f944a439f070a8eca3e4fe352e41958c55c24bb41502d0a52c34de5b0273"
    sha256 cellar: :any,                 sonoma:        "b97f0af3c785ea395f7839dd26963b8760502b77ebba09f19d6d7250d0c0f090"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cddc772e19f285df16a76407672c04ce0e69e54e04f9fe80ac1028814a3a81d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0908fcf12ddcc240126a6b15addfbe2d3b4e5758786b541f3847f2a39d58703a"
  end

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV["HOMEBREW_CAPSTONE"] = "1"
    ENV["PREFIX"] = prefix
    system "./make.sh"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # code comes from https://www.capstone-engine.org/lang_c.html
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <inttypes.h>
      #include <capstone/capstone.h>
      #define CODE "\\x55\\x48\\x8b\\x05\\xb8\\x13\\x00\\x00"

      int main()
      {
        csh handle;
        cs_insn *insn;
        size_t count;
        if (cs_open(CS_ARCH_X86, CS_MODE_64, &handle) != CS_ERR_OK)
          return -1;
        count = cs_disasm(handle, CODE, sizeof(CODE)-1, 0x1000, 0, &insn);
        if (count > 0) {
          size_t j;
          for (j = 0; j < count; j++) {
            printf("0x%"PRIx64":\\t%s\\t\\t%s\\n", insn[j].address, insn[j].mnemonic,insn[j].op_str);
          }
          cs_free(insn, count);
        } else
          printf("ERROR: Failed to disassemble given code!\\n");
        cs_close(&handle);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lcapstone", "-o", "test"
    system "./test"
  end
end
