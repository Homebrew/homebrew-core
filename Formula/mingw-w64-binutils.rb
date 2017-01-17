class MingwW64Binutils < Formula
  desc "Binutils for Windows mingw-w64 (32 and 64 bits)"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/binutils/binutils-2.27.tar.gz"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.27.tar.gz"
  sha256 "26253bf0f360ceeba1d9ab6965c57c6a48a01a8343382130d1ed47c468a3094f"

  def install
    system "./configure", "--disable-werror",
                          "--target=x86_64-w64-mingw32",
                          "--enable-targets=x86_64-w64-mingw32,i686-w64-mingw32",
                          "--prefix=#{prefix}",
                          "--with-sysroot=#{prefix}"
    system "make"
    system "make", "install"

    # Info pages and localization files conflict with native tools
    info.rmtree
    (share/"locale").rmtree
  end

  test do
    # Check target and version number
    assert_match "x86_64-w64-mingw32", shell_output("#{bin}/x86_64-w64-mingw32-as --version")
    assert_match version.to_s, shell_output("#{bin}/x86_64-w64-mingw32-ld --version")

    # Assemble a simple 64-bit routine
    (testpath/"test.s").write <<-EOS.undent
      foo:
        pushq  %rbp
        movq   %rsp, %rbp
        movl   $42, %eax
        popq   %rbp
        ret
    EOS
    system "#{bin}/x86_64-w64-mingw32-as", "-o", "test.o", "test.s"
    assert_match "file format pe-x86-64", shell_output("#{bin}/x86_64-w64-mingw32-objdump -a test.o")

    # Assemble a simple 32-bit routine
    (testpath/"test32.s").write <<-EOS.undent
      _foo:
        pushl  %ebp
        movl   %esp, %ebp
        movl   $42, %eax
        popl   %ebp
        ret
    EOS
    system "#{bin}/x86_64-w64-mingw32-as", "--32", "-o", "test32.o", "test32.s"
    assert_match "file format pe-i386", shell_output("#{bin}/x86_64-w64-mingw32-objdump -a test32.o")
  end
end
