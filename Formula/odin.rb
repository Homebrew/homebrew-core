class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2023-05",
      revision: "0c3522133d60870e123b7d0e2aacb15c38e377f8"
  version "2023-05"
  license "BSD-3-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "97efedabfdc449ab06f493b3b499391600657b2d1daada67c8244b25113231cf"
    sha256 cellar: :any,                 arm64_monterey: "1bf8741bd0173aa7c6c176a4c7c2c243db210fe1c498416a81a7480b40210cf5"
    sha256 cellar: :any,                 arm64_big_sur:  "88628114f666583b8148bf12f5d0159395805972632a105ee7d6ec0b38eb3b10"
    sha256 cellar: :any,                 ventura:        "bdc3bd46ddc7989db1f603f37c2144fc4e16ae19d4bd1f513591bdb16bf06b9c"
    sha256 cellar: :any,                 monterey:       "2d3dd3f7aead2d2535470abf23429576fdbe6877eec2ea9f33773bb8b2a77bc6"
    sha256 cellar: :any,                 big_sur:        "c21a942ab23c69ce3ccb9bca826c18d2ab61096b10fdc2cbda38e4d035cf3340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18c52720dac09ae59e5d5b84e5bdf54a3bf874a063cd7c87d7123dfdd0b83e13"
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
