class Capstone < Formula
  desc "Multi-platform, multi-architecture disassembly framework"
  homepage "https://www.capstone-engine.org/"
  url "https://github.com/capstone-engine/capstone/archive/refs/tags/5.0.5.tar.gz"
  sha256 "3bfd3e7085fbf0fab75fb1454067bf734bb0bebe9b670af7ce775192209348e9"
  license "BSD-3-Clause"
  head "https://github.com/capstone-engine/capstone.git", branch: "next"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1c3da7d71701212fee2fc19fff9bf62096d490c17e60b4eec455628270b0ded5"
    sha256 cellar: :any,                 arm64_sonoma:  "b1064e0a6ec3c0d879cbdfe241e0f07d15e45da41d76687496751d6c59413017"
    sha256 cellar: :any,                 arm64_ventura: "03937ed3eeec92f076cf96d499dcf03c5662563af09dcd4af3794d6d2afe09fc"
    sha256 cellar: :any,                 sonoma:        "711163343b8868aa9667a4d42967e3904b5061e91df878ae8cb9119e53fc89af"
    sha256 cellar: :any,                 ventura:       "9529d3a62e7f73079e7caee2f37dede263353a84aa2b3c30b025cdb27a7745b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48805c1e946305efc7cef8e50903fefbb4fc8c1ad292df2eb2d21fb7a4cd3f5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d839f160daddbc91c6ae416e827c51b4b5429f6eccf9619e8cfe27f8504ec8f"
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
