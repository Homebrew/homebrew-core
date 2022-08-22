class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2022-09",
      revision: "74458ab09676d3b66364f8c4679afb53fcf1b4f7"
  version "2022-09"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4e95122e822e002306ad30b2b2cc4b8f628abc0f21cd1c220858db1532887972"
    sha256 cellar: :any,                 arm64_big_sur:  "2dc9ee51d30c26667ec7b027cbf7890c853c4ae7d010b18ccfa1d8382a851a66"
    sha256 cellar: :any,                 monterey:       "0a92ab90c5e3b34bde6b1005629585a85126cbfb2548aac0d7ecb0b48783ba2d"
    sha256 cellar: :any,                 big_sur:        "60721f75955230beb35c08c52167ec78b9491a0d2e56d8f6e4ec31b976978c76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a12d2857a52e0757a1e6f15288d1d72fdc77cf2ba114ef8358f32bbdcae7bbc"
  end

  depends_on "llvm@14"
  # Build failure on macOS 10.15 due to `__ulock_wait2` usage.
  # Issue ref: https://github.com/odin-lang/Odin/issues/1773
  depends_on macos: :big_sur

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
