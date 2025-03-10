class Fasmg < Formula
  desc "New assembly engine designed as a successor of the one used by flat assembler 1"
  homepage "https://flatassembler.net"
  url "https://flatassembler.net/fasmg.kp60.zip"
  version "kp60"
  sha256 "cd18f546c04007226fe0ce5bea874d14382911ed4f5a1995f6bde913e7e4e751"
  license "BSD-3-Clause"
  head "https://github.com/tgrysztar/fasmg.git", branch: "master"

  livecheck do
    url "https://flatassembler.net/download.php"
    regex(/href=.*?fasmg\.([0-9a-zA-Z]+)\.zip/i)
  end

  depends_on arch: :x86_64

  def install
    chmod "+x", "./source/macos/x64/fasmg"
    system "./source/macos/x64/fasmg", "./source/macos/x64/fasmg.asm", "./fasmg"
    chmod "+x", "fasmg"
    bin.install "fasmg"
    doc.install Dir["docs/*"]
    (pkgshare/"examples").install Dir["examples/*"]
  end

  test do
    includedir = pkgshare/"examples/x86/include"
    (testpath/"hello.asm").write <<~EOS
      include '#{includedir}/x64.inc'
      macro format?.MachO64? variant
        match , variant
          MachO.Settings.ProcessorType = CPU_TYPE_X86_64
          MachO.Settings.FileType equ MH_OBJECT
          include '#{includedir}/format/macho.inc'
          use64
        else match =executable?, variant
          MachO.Settings.ProcessorType = CPU_TYPE_X86_64
          MachO.Settings.BaseAddress = 0x1000
          include '#{includedir}/format/macho.inc'
          use64
        else
          err 'invalid argument'
        end match
      end macro

      format MachO64
      public _main

      segment '__TEXT' readable executable

      section '__text' align 16

      message db 'Hello, world!', 0x0A
      message_len = $ - message

      _main:
        mov     rax, 0x2000004
        mov     rdi, 1
        lea     rsi, [message]
        mov     rdx, message_len
        syscall
        mov     rax, 0x2000001
        mov     rdi, 0
        syscall
        ret
    EOS
    system bin/"fasmg", "hello.asm", "hello.o"
    assert_path_exists testpath/"hello.o"
    system ENV.cc, "hello.o", "-o", "hello"
    assert_path_exists testpath/"hello"
    assert_equal "Hello, world!\n", shell_output("./hello")
  end
end
