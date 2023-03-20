class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2023-03",
      revision: "2d71ab6f2907c14651da8fb231a695b4a60f2c68"
  version "2023-03"
  license "BSD-3-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6430a89638b77ea2870e0d61efd768cbcaafaa48fb4b0568ec23e2103a2916f9"
    sha256 cellar: :any,                 arm64_monterey: "a0ad1dfb7edf4c0ef8cbe97d0d2eb41973d2b41943e4602331df7b8fed5f2982"
    sha256 cellar: :any,                 arm64_big_sur:  "6fcac62caf3b82bd63fb56541e1c73b16517db7f17c447df25098b4bb38b87f0"
    sha256 cellar: :any,                 ventura:        "182a2c249d8b6b1895efae2a2732cf5dd8c07766f0161a5688324cb1790d3379"
    sha256 cellar: :any,                 monterey:       "2edfd958ddca8142cf7f58c4bca603e5683ab291f0d08c12355ae184028868e5"
    sha256 cellar: :any,                 big_sur:        "c5452bf4ccc058b84ca55ca53c165fc431876cc837efdcb5b8ffe05aafcabe9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d300f5c76a9456eda725119d97dae087d9f8c6e27d73809dcbf09750c0e4169"
  end

  depends_on "llvm@14"

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
    assert_equal "Hellope!\n", shell_output("./hellope.bin")
  end
end
