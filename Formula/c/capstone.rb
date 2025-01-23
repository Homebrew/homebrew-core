class Capstone < Formula
  desc "Multi-platform, multi-architecture disassembly framework"
  homepage "https://www.capstone-engine.org/"
  url "https://github.com/capstone-engine/capstone/archive/refs/tags/5.0.3.tar.gz"
  sha256 "3970c63ca1f8755f2c8e69b41432b710ff634f1b45ee4e5351defec4ec8e1753"
  license "BSD-3-Clause"
  head "https://github.com/capstone-engine/capstone.git", branch: "next"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "1bfbe3ed3ee90ede3b80ccef52d4cab75c81d215870ecd50d4bf6b30ba60b84d"
    sha256 cellar: :any,                 arm64_sonoma:   "2c1c08af469f0307469b70ff6c277d5971495db3a8c7ae38c98bd2c70745acbb"
    sha256 cellar: :any,                 arm64_ventura:  "8960b1111e9a59597c9c50a6b7ec3cfcfbc5e845d28bb2f42507a2d7bb108a71"
    sha256 cellar: :any,                 arm64_monterey: "9fadfcd6aa4f0a077472715e2c9cd8da5e64c47d4e025a944525e70835619fbb"
    sha256 cellar: :any,                 sonoma:         "87442182a186180fa0a4a8bdf3eef0acff55cd732001b191a83f032701520ca9"
    sha256 cellar: :any,                 ventura:        "bcc3c9288b93bf10c8c10a08352bba47767bf1ffe147c9a6a5bb6e8567fb15de"
    sha256 cellar: :any,                 monterey:       "eedc593b4cd8ff6baee45009248224d9a227abef8d4db98db868a42e5ae4c49d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d8ed2e019394daca38715f2c7ab67fc2076c54aeb40e0a4d048d798ba0c51ba"
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
