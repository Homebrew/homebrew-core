class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2022-10",
      revision: "79fe30321ab571038f8d3822ce989becd2336306"
  version "2022-10"
  license "BSD-3-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fb2c7a8f5e70a163fe33c5c3a01511b46ad20df5572dc74189e6d9ee44acb0d5"
    sha256 cellar: :any,                 arm64_big_sur:  "af49d6f31c7e51fae2c5a549289345f204db2d0f85466b1c17268b08079cd6eb"
    sha256 cellar: :any,                 monterey:       "48bac09a245cfd16d90e020743240ffc0999216c732959d1577d3e9bca3e2fd8"
    sha256 cellar: :any,                 big_sur:        "31253af41aa2738f0519de5b1e7686eb632b47f966654ab6aa16e9e87ae7690f"
    sha256 cellar: :any,                 catalina:       "d66274f4485b95c90cf113afcaa228d9eaa3f1c5b1a48271158ccbbc0a209ad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "720c24213b0f7b59875edc81d322d787903d40879f536a837fb28f429225cc5c"
  end

  depends_on "llvm@14"

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }

    # Keep version number consistent and reproducible for tagged releases.
    # Issue ref: https://github.com/odin-lang/Odin/issues/1772
    inreplace "build_odin.sh", "dev-$(date +\"%Y-%m\")", "dev-#{version}" unless build.head?

    system "make", "release"
    libexec.install "odin", "core", "shared"
    (bin/"odin").write <<~EOS
      #!/bin/bash
      export PATH="#{llvm.opt_bin}:$PATH"
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
    system "#{bin}/odin", "build", "hellope.odin", "-file"
    assert_equal "Hellope!\n", shell_output("./hellope.bin")
  end
end
