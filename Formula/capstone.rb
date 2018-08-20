class Capstone < Formula
  desc "Multi-platform, multi-architecture disassembly framework"
  homepage "https://www.capstone-engine.org/"
  url "https://github.com/aquynh/capstone/archive/3.0.5.tar.gz"
  sha256 "913dd695e7c5a2b972a6f427cb31f2e93677ec1c38f39dda37d18a91c70b6df1"
  head "https://github.com/aquynh/capstone.git"

  bottle do
    cellar :any
    sha256 "15cc782e0990bd7b4f531a4bc18c14f2c34318355e3f56d10225d3e26af9306c" => :mojave
    sha256 "90c24c16624b06137aeec9cf9040c6cf91ccc5045a4fa5606c4ee39be8b06991" => :high_sierra
    sha256 "e3cd9819d2ff6cc1ee026458463c939070085a78558a99a85aab34243f7f63ea" => :sierra
    sha256 "8d2b3cb82b16a0e40242f9413335fbdb60d99860e2f3ba85a4dab442fc72f804" => :el_capitan
  end

  def install
    ENV["HOMEBREW_CAPSTONE"] = "1"
    ENV["PREFIX"] = prefix
    system "./make.sh"
    system "./make.sh", "install"
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
