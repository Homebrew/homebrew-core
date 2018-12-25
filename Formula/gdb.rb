class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-8.2.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-8.2.1.tar.xz"
  sha256 "0a6a432907a03c5c8eaad3c3cffd50c00a40c3a5e3c4039440624bae703f2202"

  bottle do
    rebuild 1
    sha256 "2ff3361e32ecceb497d4e8d88063152317ddc6f74b5720ab90942c360a24939d" => :mojave
    sha256 "b6cc9d077d71cf364221f17fc1c88de3f7a87dfda371d5a28f28042ccaed6484" => :high_sierra
    sha256 "874e1c4873a315ff27660a1f63b430653f292488207053c6f97c35d942602756" => :sierra
  end

  depends_on "pkg-config" => :build

  fails_with :clang do
    build 800
    cause <<~EOS
      probe.c:63:28: error: default initialization of an object of const type
      'const any_static_probe_ops' without a user-provided default constructor
    EOS
  end

  fails_with :clang do
    build 600
    cause <<~EOS
      clang: error: unable to execute command: Segmentation fault: 11
      Test done on: Apple LLVM version 6.0 (clang-600.0.56) (based on LLVM 3.5svn)
    EOS
  end

  # Remove if 8.3+ Taken from
  # https://patches-gcc.linaro.org/patch/10133/
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --enable-targets=all
      --with-python=/usr
    ]

    system "./configure", *args
    system "make"

    # Don't install bfd or opcodes, as they are provided by binutils
    inreplace ["bfd/Makefile", "opcodes/Makefile"], /^install:/, "dontinstall:"

    system "make", "install"
  end

  def caveats; <<~EOS
    gdb requires special privileges to access Mach ports.
    You will need to codesign the binary. For instructions, see:

      https://sourceware.org/gdb/wiki/BuildingOnDarwin

    On 10.12 (Sierra) or later with SIP, you need to run this:

      echo "set startup-with-shell off" >> ~/.gdbinit
  EOS
  end

  test do
    system bin/"gdb", bin/"gdb", "-configuration"
  end
end
__END__
diff --git a/gdb/aarch64-linux-tdep.c b/gdb/aarch64-linux-tdep.c
index 99e6a15..3d80568 100644
--- a/gdb/aarch64-linux-tdep.c
+++ b/gdb/aarch64-linux-tdep.c
@@ -315,7 +315,7 @@ aarch64_linux_supply_sve_regset (const struct regset *regset,
      passed in SVE regset or a NEON fpregset.  */

   /* Extract required fields from the header.  */
-  uint64_t vl = extract_unsigned_integer (header + SVE_HEADER_VL_OFFSET,
+  ULONGEST vl = extract_unsigned_integer (header + SVE_HEADER_VL_OFFSET,
 					  SVE_HEADER_VL_LENGTH, byte_order);
   uint16_t flags = extract_unsigned_integer (header + SVE_HEADER_FLAGS_OFFSET,
 					     SVE_HEADER_FLAGS_LENGTH,
