class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2023-12",
      revision: "31b1aef44e1b0178f10f5faa62ceedddda56667b"
  version "2023-12"
  license "BSD-3-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9119afc9a856b79c48b73472034a5ad086c37ad6a7d4730099601c0132c29191"
    sha256 cellar: :any,                 arm64_ventura:  "26139f906eaa345bb08e6e41bdb482a691aeeecaaedccb215e38c56f07f65625"
    sha256 cellar: :any,                 arm64_monterey: "bf1e9e76c36940d62aa1d1d83b3a3550dbd95b8d3032e89e0f1acf8566bd0f68"
    sha256 cellar: :any,                 sonoma:         "5177812452b2427f32a7a8282a9b87be5978d06f271de2f86a770fdbd2e14c08"
    sha256 cellar: :any,                 ventura:        "e6896f7b2c677271641a6dc3cf38e73ed53da67e808ff129eceeceb017d46661"
    sha256 cellar: :any,                 monterey:       "9e29ac8f8696673245a0ff22b37cee689a4e37e227f712be6514b3d6247ab12c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e962f864421dd8f070b775c44821fcc0ae42c9dfd2bc4ecf20f53e47169278d"
  end

  depends_on "llvm"

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }

    # Keep version number consistent and reproducible for tagged releases.
    args = []
    args << "ODIN_VERSION=dev-#{version}" unless build.head?
    system "make", "release", *args
    libexec.install "odin", "core", "shared", "vendor"
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
