class Odin < Formula
  desc "The Odin Programming Language"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin/archive/v0.12.0.tar.gz"
  sha256 "8356124c8cc7e08ac39872e5bb10593a412e67f81df621124097facd9b2b26cc"
  revision 1
  head "https://github.com/odin-lang/Odin.git"

  bottle do
    cellar :any
    sha256 "742f1adfd7a9ff880ad2fb80759e3a239530f6774bcf77ca5b5f650e88b3ee31" => :catalina
    sha256 "80b0b0d73769b90551a5e759d82b41e16af6993540936dc2e94363e46ac1b0c1" => :mojave
    sha256 "579b027ea67fcb8d0095f2a49e96a6660c903474bb145f930406caea8cc15ae7" => :high_sierra
  end

  depends_on "llvm"

  uses_from_macos "libiconv"

  def install
    system "make", "release"
    libexec.install "odin", "core", "shared"
    (bin/"odin").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["llvm"].opt_bin}:$PATH"
      exec -a odin "#{libexec}/odin" "$@"
    EOS
    pkgshare.install "examples"
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
