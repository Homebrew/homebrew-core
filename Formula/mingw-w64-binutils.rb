class MingwW64Binutils < Formula
  desc "Binutils for Windows mingw-w64 (32 and 64 bits)"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/binutils/binutils-2.27.tar.gz"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.27.tar.gz"
  sha256 "26253bf0f360ceeba1d9ab6965c57c6a48a01a8343382130d1ed47c468a3094f"

  bottle do
    sha256 "6bc55401f311a9f5df14cf01c2e87e414952f60eb4de91f1a04ebf6f7ef1668a" => :sierra
    sha256 "328d6d452200f6c4babd2607bf0b7ed622f6ff3198eb172ad6ad5a769a69c70b" => :el_capitan
    sha256 "39e04cd72f16ce87abac183cfa9d1bfe3b979378a938f4a8b987b79ea696261d" => :yosemite
  end

  option "without-i686", "Compile without i686 mingw target"
  option "without-x86_64", "Compile without x86_64 mingw target"
  option "without-multilib", "Compile x86_64 mingw target without multilib"

  def targets
    if build.without?("i686") && build.without?("x86_64")
      odie "Options --without-i686 and --without-x86_64 are mutually exclusive"
    end
    archs = []
    archs.push("i686-w64-mingw32") if build.with?("i686")
    archs.push("x86_64-w64-mingw32") if build.with?("x86_64")
  end

  def install
    targets.each do |target_arch|
      args = %W[
        --disable-werror
        --target=#{target_arch}
        --prefix=#{prefix}
        --with-sysroot=#{prefix}
      ]
      args.push("--disable-multilib", "--enable-target=#{target_arch}") if target_arch.start_with?("i686") || build.without?("multilib")
      args.push("--enable-multilib", "--enable-target=#{target_arch},i686-w64-mingw32") if target_arch.start_with?("x86_64") && build.with?("multilib")

      mkdir "build-#{target_arch}" do
        system "../configure", *args
        system "make"
        system "make", "install"
      end

      # Info pages and localization files conflict with native tools
      info.rmtree
      (share/"locale").rmtree
    end
  end

  test do
    # Assemble a simple 64-bit routine
    (testpath/"test.s").write <<-EOS.undent
      foo:
        pushq  %rbp
        movq   %rsp, %rbp
        movl   $42, %eax
        popq   %rbp
        ret
    EOS

    # Assemble a simple 32-bit routine
    (testpath/"test32.s").write <<-EOS.undent
      _foo:
        pushl  %ebp
        movl   %esp, %ebp
        movl   $42, %eax
        popl   %ebp
        ret
    EOS
    targets.each do |target_arch|
      if target_arch.start_with?("i686") || (target_arch.start_with?("x86_64") && build.with?("multilib"))
        system "#{bin}/#{target_arch}-as", "--32", "-o", "test32.o", "test32.s"
        assert_match "file format pe-i386", shell_output("#{bin}/#{target_arch}-objdump -a test32.o")
        system "#{bin}/#{target_arch}-ld", "-m", "i386pe", "-o", "test32.exe", "test32.o"
        assert_match "PE32 executable", shell_output("file test32.exe")
      end
      next unless target_arch.start_with?("x86_64")
      system "#{bin}/#{target_arch}-as", "-o", "test.o", "test.s"
      assert_match "file format pe-x86-64", shell_output("#{bin}/#{target_arch}-objdump -a test.o")
      system "#{bin}/#{target_arch}-ld", "-o", "test.exe", "test.o"
      assert_match "PE32+ executable", shell_output("file test.exe")
    end
  end
end
