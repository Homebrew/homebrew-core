class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2023-10",
      revision: "2cca00505601f0b0e76719d366a037cdb4cf794c"
  version "2023-10"
  license "BSD-3-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3eb79e06a3d1ed4f51f83d0933296d5ed26b63e2bb4a35e3296a76a382be925c"
    sha256 cellar: :any,                 arm64_ventura:  "9316a3d0a33841edfc1828d61a304de9ee19a27b0ac9ebf956f2483631aa636c"
    sha256 cellar: :any,                 arm64_monterey: "a4a91b1745449fc0049a702c4e892a0a31fba313de62a8e204eb123b655eb3fb"
    sha256 cellar: :any,                 sonoma:         "5070b5a4c3ad5721cc7ef57b0a49af73c5fc290a6c6261a3e0e64911e8f140a9"
    sha256 cellar: :any,                 ventura:        "4401ec13fac3cde945739638bc58cb8c99780442db2fa2f8c17b1e4cc5dabc59"
    sha256 cellar: :any,                 monterey:       "a0cafc8faeb7220b720c81648807f9e2cecc6a6d498b80e48a7e88c7594e4ec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2b1a29c12eefc435eea5f08f925df165c9925314ea20b93d44dc7c61295ef15"
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
    assert_equal "Hellope!\n", shell_output("./hellope")
  end
end
