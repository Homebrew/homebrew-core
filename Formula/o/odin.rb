class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2023-11",
      revision: "ef5eb4b612eed1a51186b9182a5e61b79ce36d06"
  version "2023-11"
  license "BSD-3-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "93af45610d8f48a5c225c0bd2fe07078adfba2b2e133407fb4deaf80c4769d43"
    sha256 cellar: :any,                 arm64_ventura:  "3b820845c78c05f16012ecdcb4cf0615351b695d7dce8164fe0bdda09a5a7195"
    sha256 cellar: :any,                 arm64_monterey: "5940427a8ada6d66bd784b6fd68b31ac492f20db432d5d324f77283a1b7d16af"
    sha256 cellar: :any,                 sonoma:         "f339debbe7d65f0cac2f4aa105c9e58d20a07a9f47f774e870f54d9d0c41dc56"
    sha256 cellar: :any,                 ventura:        "b898c58bee3f81be43ec1507ce7fcf2ea80a084f11987283d3f45a8830ae63a9"
    sha256 cellar: :any,                 monterey:       "48fe72b2c15418683a8c38f6e06fbf7a7a0e849d656c975604ac8865ca3a338e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb56380bb076af6ccad3851127cc330870a4dfc45b9574cdba5979ff382cc3ea"
  end

  depends_on "llvm"

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }

    # Keep version number consistent and reproducible for tagged releases.
    args = []
    args << "ODIN_VERSION=dev-#{version}" unless build.head?
    system "make", "release", *args
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
    assert_equal "Hellope!\n", shell_output("./hellope")
  end
end
