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
    if OS.linux?
      os = "linux"
      fasmg = "./fasmg.x64"
    elsif OS.mac?
      os = "macos"
      fasmg = "./source/#{os}/x64/fasmg"
    end

    chmod "+x", fasmg
    system fasmg, "./source/#{os}/x64/fasmg.asm", "./fasmg"
    chmod "+x", "fasmg"
    bin.install "fasmg"
    doc.install Dir["docs/*"]
    (pkgshare/"examples").install Dir["examples/*"]
  end

  test do
    ENV["INCLUDE"] = pkgshare/"examples/x86/include"

    if OS.mac?
      (testpath/"hello.asm").write <<~EOS
        include 'format/format.inc'
        format MachO64
        public _main

        segment '__TEXT' readable executable

        section '__cstring' align 1
        message db 'Hello, world!', 0x0A
        message_len = $ - message

        section '__text' align 16
        _main:
          mov rax, 0x2000004
          mov rdi, 1
          lea rsi, [message]
          mov rdx, message_len
          syscall
          mov rax, 0x2000001
          xor rdi, rdi
          syscall
          ret
      EOS
      system bin/"fasmg", "hello.asm", "hello.o"
      assert_path_exists testpath/"hello.o"
      system ENV.cc, "hello.o", "-o", "hello"
    elsif OS.linux?
      (testpath/"hello.asm").write <<~EOS
        include 'format/format.inc'
        format ELF64 executable 3
        entry _start

        segment readable executable
        _start:
          mov rax, 1
          mov rdi, 1
          mov rsi, message
          mov rdx, message_len
          syscall
          mov rax, 60
          xor rdi, rdi
          syscall

        segment readable
          message db 'Hello, world!', 0x0A
          message_len = $ - message
      EOS
      system bin/"fasmg", "hello.asm", "hello"
    end

    chmod "+x", "hello"
    assert_path_exists testpath/"hello"
    assert_equal "Hello, world!\n", shell_output("./hello")
  end
end
