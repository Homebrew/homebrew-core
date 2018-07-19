class Capstone < Formula
  desc "Multi-platform, multi-architecture disassembly framework"
  homepage "https://www.capstone-engine.org/"
  url "https://github.com/aquynh/capstone/archive/3.0.5.tar.gz"
  sha256 "913dd695e7c5a2b972a6f427cb31f2e93677ec1c38f39dda37d18a91c70b6df1"
  head "https://github.com/aquynh/capstone.git"

  bottle do
    cellar :any
    sha256 "82e40e06f3a41633326d3ceb7f268945441dcb7a0ae1caa88e06fc0504c73cc0" => :high_sierra
    sha256 "7d0f04a49d42bd9c953a5ea6cb85159f72f8e948d6aea4d7c64b3e82a12459f1" => :sierra
    sha256 "3aa8d8b679cc5261a3fbf44b191c61480cdb34576f71b769e63d68c5e27c19b1" => :el_capitan
    sha256 "5bbd8f7d9e0ae0d3b23c7d478fdb02476e8cee847577576d543bf98649985975" => :yosemite
    sha256 "0cfd7478b21360ffea1aac61ec64eeae612bce247a681b0205ffd14790f8f7dc" => :mavericks
    sha256 "585042b1452fbeda9efd07da4b8400d56d166afd5e5f1120da20975e41001e88" => :mountain_lion
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
