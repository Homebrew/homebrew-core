class Capstone < Formula
  desc "Multi-platform, multi-architecture disassembly framework"
  homepage "https://www.capstone-engine.org/"
  url "https://github.com/aquynh/capstone/archive/4.0.2.tar.gz"
  sha256 "7c81d798022f81e7507f1a60d6817f63aa76e489aa4e7055255f21a22f5e526a"
  license "BSD-3-Clause"
  head "https://github.com/aquynh/capstone.git", branch: "next"

  bottle do
    cellar :any
    sha256 "21dd5b41e81b165e0419901103aa46ab8afee2be5453b2076c8f7a5b94fdf211" => :big_sur
    sha256 "5c2d67aeb32a36c76d1918ec10de347971b385fc73b3025c97639467dc5302e2" => :arm64_big_sur
    sha256 "b434ee96e9d7c413e289340b280705a6c3b9929cf1859de865d88bc012c34396" => :catalina
    sha256 "c90885740ef54af155c2a0151dc85f728a3aa7ca304a45510e5524ac7fecb7fc" => :mojave
    sha256 "c6d974a3c237fc36bfea2042d95551f2be7197d37fc0df6c7b9ea2179cd01084" => :high_sierra
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
