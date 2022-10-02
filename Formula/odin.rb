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
    sha256 cellar: :any,                 arm64_monterey: "060b19df4c64ad284cc3bf4f4c5cac35481c60b792d788f7a9df8f77ff43bb66"
    sha256 cellar: :any,                 arm64_big_sur:  "c55c9fdd113dceadbbf46f16894f5dc3225eff30ac3f5884501905ea02a5ccb8"
    sha256 cellar: :any,                 monterey:       "46cb8ef05f5eb318f838fe26bf03f5b2b53c2eec7383ca2d4596869949c1b17a"
    sha256 cellar: :any,                 big_sur:        "43b30072088d6540c0c5dcbd10d22d887fa89b7f2068e0d58922d4bb1ff2a081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b616ffb6882e66385e008469cd02cbf129f7e2c0cec01b5e8cfad1eba517ccf"
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
