class Aletheia < Formula
  desc "Self-hosting C compiler bootstrapped from raw machine code"
  homepage "https://github.com/iyotee/Aletheia"
  url "https://github.com/iyotee/Aletheia/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "2947270c2512271b24995d83b791cde89ffcfce233b412310253aecb8ef3d9e8"
  license "MIT"

  depends_on "gcc" => :build
  depends_on "make" => :build

  def install
    # Build the compiler
    # Try GCC first, fallback to system compiler
    if Formula["gcc"].installed?
      ENV["CC"] = Formula["gcc"].opt_bin/"gcc"
    else
      ENV["CC"] = ENV["HOMEBREW_CC"] || "cc"
    end

    system "make", "CC=#{ENV["CC"]}"

    # Install binaries
    bin.install "build/aletheia_compiler" => "aletheia"
    bin.install "build/assembler"
    bin.install "build/linker"
    bin.install "build/bootstrap_emitter"

    # Install documentation
    doc.install "README.md"
    doc.install Dir["docs/*.md"]
  end

  test do
    # Test basic compilation
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("Hello from ALETHEIA!\\n");
        return 0;
      }
    EOS

    # Compile to assembly
    system "#{bin}/aletheia", "hello.c", "hello.s"
    assert_predicate testpath/"hello.s", :exist?

    # Compile to binary
    system "#{bin}/aletheia", "-b", "hello.c", "hello.bin"
    assert_predicate testpath/"hello.bin", :exist?
  end
end
