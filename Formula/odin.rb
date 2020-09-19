class Odin < Formula
  desc "The Odin Programming Language"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin/archive/v0.13.0.tar.gz"
  sha256 "ae88c4dcbb8fdf37f51abc701d94fb4b2a8270f65be71063e0f85a321d54cdf0"
  license "BSD-2-Clause"
  head "https://github.com/odin-lang/Odin.git"

  livecheck do
    url "https://github.com/odin-lang/Odin/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "fa220553a803117a6da6b751710098c3bab7149548328d34fcc0e20d46a208ef" => :catalina
    sha256 "55a364b6cf75db9dbb38a0f0bba169e26ccc291d9c1e7e61db943e1c43c3aa7a" => :mojave
    sha256 "5db7f315b542a5c648a72a682a8f026dbfd37c9ebacf81cdb29cde972b023cbc" => :high_sierra
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
