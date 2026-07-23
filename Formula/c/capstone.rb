class Capstone < Formula
  desc "Multi-platform, multi-architecture disassembly framework"
  homepage "https://www.capstone-engine.org/"
  url "https://github.com/capstone-engine/capstone/archive/refs/tags/5.0.9.tar.gz"
  sha256 "0619da31af08152600af95c481527ef6d756c0a8404fca7544a4fdf6dfc2c0f9"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/capstone-engine/capstone.git", branch: "next"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "136ef83fb2c78de33a0500d8e9d3628eb1db37d4ef00496e8027e00a5918eb33"
    sha256 cellar: :any,                 arm64_sequoia: "a6fbf1343829afa5521e8fdba9f0d05246cad3c8caf4833af6d826baaf0db795"
    sha256 cellar: :any,                 arm64_sonoma:  "bbe5f0825fb2511229677b4cd56d88b7c85efc88b537acfc77c41266424983ae"
    sha256 cellar: :any,                 sonoma:        "4c2563fd3750dcfc7bff7a99876034b68257f9979c336fa16da730435736832c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e62999052f399dc5c10cf74036108f585789ae2a2b28842aa1677ca99e027b08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c724d5267658f8e1d10a4e050e5e56ed3db99f4ef454e9340a43e0eaafe7050"
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
