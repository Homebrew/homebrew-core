class Orbiton < Formula
  desc "Fast and configuration-free text editor and IDE limited by VT100"
  homepage "https://orbiton.zip/"
  license "BSD-3-Clause"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/xyproto/orbiton/releases/download/v2.64.1/orbiton-2.64.1-macos_x86_64_static.tar.gz"
      sha256 "de888428b2f0cf2de16d9f80169b072e8eba16e6ed734a73af2cbc6522940e02"
    elsif Hardware::CPU.arm?
      url "https://github.com/xyproto/orbiton/releases/download/v2.64.1/orbiton-2.64.1-macos_aarch64_static.tar.gz"
      sha256 "c8958b4e34083b8c9bec42f102d58066c7052d11252b2ccc5a23eaae8f8e2be7"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/xyproto/orbiton/releases/download/v2.64.1/orbiton-2.64.1-linux_x86_64_static.tar.xz"
      sha256 "758752be25eb2d3e50fa4b6ded26da810151520af384f6908d65a97d0afac1ea"
    elsif Hardware::CPU.arm?
      if Hardware::CPU.is_64_bit?
        url "https://github.com/xyproto/orbiton/releases/download/v2.64.1/orbiton-2.64.1-linux_aarch64_static.tar.xz"
        sha256 "40aebb06a31e683a761681fd3730ac1945103957a3802b58d432df84e0a70969"
      else
        url "https://github.com/xyproto/orbiton/releases/download/v2.64.1/orbiton-2.64.1-linux_armv7_static.tar.xz"
        sha256 "8d87c858030c7837996216bc05c08500aae9e002a16c1d2b2714d139e996dad2"
      end
    elsif Hardware::CPU.riscv? && Hardware::CPU.is_64_bit?
      url "https://github.com/xyproto/orbiton/releases/download/v2.64.1/orbiton-2.64.1-linux_riscv64_static.tar.xz"
      sha256 "5a83d9f1b30b797b2127a2db0b7e753ee0ad5b22d0e8ed2ee6a4dbac7517fc52"
    end
  end

  def install
    bin.install "o"
    man1.install "o.1.gz"
  end

  test do
    # Test 1: Check if 'o --version' output contains "Orbiton"
    assert_match "Orbiton", shell_output("#{bin}/o --version")

    # Test 2: Check if copying and pasting a file with 'o' works
    (testpath/"hello.txt").write "hello\n"
    system "#{bin}/o", "-c", "#{testpath}/hello.txt" # copy the contents of hello.txt to the clipboard
    system "#{bin}/o", "-p", "#{testpath}/hello2.txt" # paste the contents of the clipboard to hello2.txt
    assert_equal (testpath/"hello.txt").read, (testpath/"hello2.txt").read
  end
end
