class Capstone < Formula
  desc "Multi-platform, multi-architecture disassembly framework"
  homepage "https://www.capstone-engine.org/"
  url "https://github.com/capstone-engine/capstone/archive/refs/tags/5.0.6.tar.gz"
  sha256 "240ebc834c51aae41ca9215d3190cc372fd132b9c5c8aa2d5f19ca0c325e28f9"
  license "BSD-3-Clause"
  head "https://github.com/capstone-engine/capstone.git", branch: "next"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3d11af12bdb07cb427b9acfd92976b1aaba30d6b19e202dab45e39c2b6fd8f3f"
    sha256 cellar: :any,                 arm64_sequoia: "eb410c79448b4cb73f7b34ad6fd733d60c493d0f884be84ec40cef075615e629"
    sha256 cellar: :any,                 arm64_sonoma:  "808aee150aa07ab56497c7f4f8ea8c5a29508e12a51e04f5fd5a10b39552dd30"
    sha256 cellar: :any,                 arm64_ventura: "9c34130c8f13ab1d2f151ef58e821d3227aefc60eccccf2ed3e9ba21b07266d4"
    sha256 cellar: :any,                 sonoma:        "3222d61b83d900f610bdfbd2f16f42ac8d216254974e1dde6750cf3cbdfdcbff"
    sha256 cellar: :any,                 ventura:       "bfdcb8212326f01615b010f6c5bb359d97e402f5f233e9addd8da64a031e46e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b82b12f9c6415e7e7ded2519d7bd896bd55e8a48122dc9d7d48d1f7b65ef1ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5c2eda3e2bb749151141b634a542346c0b8fab09e0e7bbc49e841ea7f82b8d6"
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
