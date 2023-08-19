class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2023-08",
      revision: "9453b2387b2cc7c473547997703c305e7982f5e4"
  version "2023-08"
  license "BSD-3-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e888aba71f8c934fde332351468952b9b1e12de1f8d3b9ba7ae697122880848b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ef042836ecc58dea21d111b011d18f37a1ab8b911969c755b104e4009277b06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14633643eed1632d9e8066c260877197942858ad874b567f1e0472e49f603167"
    sha256 cellar: :any_skip_relocation, ventura:        "dde2a6c465c3fdf5a413cf37bc13afac54bd8c8bb35ab53661546a8cc87c4b52"
    sha256 cellar: :any_skip_relocation, monterey:       "11642e4d5c54f63289fedadeaef4844fafb2a89db221d1993b63352015a4b4d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "11a5fb1654f19524b22aeed11ad3f092e84e21477aa3e957012a73e458c3ca66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fa8e84063f90b2064218f3f60c2f6af6c53dcb7cf4332896bd9e8e41e413083"
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
