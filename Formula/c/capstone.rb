class Capstone < Formula
  desc "Multi-platform, multi-architecture disassembly framework"
  homepage "https://www.capstone-engine.org/"
  url "https://github.com/capstone-engine/capstone/archive/refs/tags/5.0.2.tar.gz"
  sha256 "9d0be727cc942075a1696f576b88918eb0daf9db7a02f563f0c4e51a439a611d"
  license "BSD-3-Clause"
  head "https://github.com/capstone-engine/capstone.git", branch: "next"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "440ca7a956e7be0241c97d261d75d84dcd548e8882c808ddbcf2a36ac7a25a96"
    sha256 cellar: :any,                 arm64_ventura:  "5f236cbf187429a9dc315def243ef5cb13e34b8d12dace1410f42423c169beb8"
    sha256 cellar: :any,                 arm64_monterey: "7a1544ddc7e39568a481979d63c2d2d00e354557d447cfd16febced5408d93da"
    sha256 cellar: :any,                 sonoma:         "113cd8ec975f07a3f5cb12daee9341fbf034c1ab716e87a45643efce720ea6d6"
    sha256 cellar: :any,                 ventura:        "98ef5274bbfe7d46a933f8ebd6ddfef30f6496055e425ffe03e7ce980b62959b"
    sha256 cellar: :any,                 monterey:       "d95a78640b9e1e367ace1930135ad0eed93f2a66f620941c19362f96af67718a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7862a6aa940dca85446ae3ab2bf4a39206644f85e58aa7d3a74403548f9be88d"
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
