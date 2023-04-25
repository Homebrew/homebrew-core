class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2023-04",
      revision: "adcaace03cc03cc4ba9c2a9e3ffa585369f6a20e"
  version "2023-04"
  license "BSD-3-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "38c194c57932c8ca4d5284145c58dec6d051dd922053becb7a7ce2a26a9965fc"
    sha256 cellar: :any,                 arm64_monterey: "4885b48331f806c4e83eb3204cfd6db8765d5841bc0152f2dd8620472dcbcd6b"
    sha256 cellar: :any,                 arm64_big_sur:  "e6a3522cdac2277df024c1b040c238fcdd0adb729d43f0ed4e18f470540fe173"
    sha256 cellar: :any,                 ventura:        "04945cf3342acc11526bd29d92e9433b1f934ea91ff4cea0c83b28c56703f1c5"
    sha256 cellar: :any,                 monterey:       "43d591792253abe6eebbac9cb60631cc37af63befffa090fc64b14069778037b"
    sha256 cellar: :any,                 big_sur:        "74d8b8a435e1f280252e2ef4f346966c0aad161d5fa6e34628efdfda035b7dd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68d2c5b5f5ea78c65274aca921f3db0ec823e32fdc443709445b1179a2162ffa"
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
