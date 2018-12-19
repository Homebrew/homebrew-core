class Capstone < Formula
  desc "Multi-platform, multi-architecture disassembly framework"
  homepage "https://www.capstone-engine.org/"
  url "https://github.com/aquynh/capstone/archive/4.0.tar.gz"
  sha256 "26c6461618670d59215635602ef5fb6f90bf6724006983af88e4983d6af1e67a"
  head "https://github.com/aquynh/capstone.git"

  bottle do
    cellar :any
    sha256 "288c67f6ebc09c9d3ad06eaa3d55fae6205085930a418747d92b36ff3bf3d4cb" => :mojave
    sha256 "677c4090d56e51d1066977a9718c5f1556a4de7eb840a0006c6d86d149862b2d" => :high_sierra
    sha256 "9f3886107e2bf01d4bd4a4dd9f7fc9f138dd65d90ee293962a9678a934191ff2" => :sierra
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
