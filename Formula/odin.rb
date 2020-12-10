class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin/archive/v0.13.0.tar.gz"
  sha256 "ae88c4dcbb8fdf37f51abc701d94fb4b2a8270f65be71063e0f85a321d54cdf0"
  license "BSD-2-Clause"
  head "https://github.com/odin-lang/Odin.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "772509e10bf0a73af78b51e4f85309eb6d25e0078d1f2fa02bfa2d252e0055ca" => :catalina
    sha256 "8e86193674aeecfc0b103cd067c39f2ac3df41d72f3875676fc21e397c9748b1" => :mojave
    sha256 "87d21cd84cc602f553a8b9533ad2fafcf8fb8d987bb5f8a25d27239a3d2d177d" => :high_sierra
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
