class Capstone < Formula
  desc "Multi-platform, multi-architecture disassembly framework"
  homepage "https://www.capstone-engine.org/"
  url "https://github.com/capstone-engine/capstone/archive/refs/tags/5.0.1.tar.gz"
  sha256 "2b9c66915923fdc42e0e32e2a9d7d83d3534a45bb235e163a70047951890c01a"
  license "BSD-3-Clause"
  head "https://github.com/capstone-engine/capstone.git", branch: "next"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1f30bfa8d92451f670c2952ebcb12ac1e44bde8ec15c5f9d420f82515ca31e9c"
    sha256 cellar: :any,                 arm64_monterey: "e6c0c2d4f68213085774d4388e29bfac941dd1adc6a4f1e8111ed418daf8adac"
    sha256 cellar: :any,                 arm64_big_sur:  "18c441a2412c0f1c772d9a728032f3513aa7e36a195a48069827e056ce362f0b"
    sha256 cellar: :any,                 ventura:        "b23198ddafc42cdb420f125d5eb36e27fe12d67d243ad63eafb1c805993f9136"
    sha256 cellar: :any,                 monterey:       "7469382171ed7d25d2e8206c7dc358cd054ea30f2d4f0bcc3ef0c9e8cedef57b"
    sha256 cellar: :any,                 big_sur:        "35f66655a1798dc2d0e03f770022ae8b5ff8530a421802fbe8e72815c49e6708"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b81dd8d867b60146e089ecf20f30efb80646a18856e7596616585f141661f9c"
  end

  def install
    ENV["HOMEBREW_CAPSTONE"] = "1"
    ENV["PREFIX"] = prefix
    system "./make.sh"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # code comes from https://www.capstone-engine.org/lang_c.html
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcapstone", "-o", "test"
    system "./test"
  end
end
