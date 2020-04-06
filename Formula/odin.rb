class Odin < Formula
  desc "The Odin Programming Language"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin/archive/v0.12.0.tar.gz"
  sha256 "8356124c8cc7e08ac39872e5bb10593a412e67f81df621124097facd9b2b26cc"
  head "https://github.com/odin-lang/Odin.git"

  depends_on "llvm"

  uses_from_macos "libiconv"

  def install
    system "make", "release"
    libexec.install "odin", "core", "shared"
    (bin/"odin").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["llvm"].opt_bin}:$PATH"
      exec -a odin #{libexec}/odin "$@"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/odin version")

    (testpath/"hellope.odin").write <<~EOS
      package main

      import "core:fmt"

      main :: proc() {
        fmt.println("Hellope!");
      }
    EOS
    system "#{bin}/odin", "build", "hellope.odin"
    assert_equal "Hellope!\n", `./hellope`
  end
end
