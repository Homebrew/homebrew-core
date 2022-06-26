class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2022-06",
      revision: "ba5f7c4e2af5c82c220b7e1796fde2f026ce4208"
  version "2022-06"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "99d3f356276eb775996a0b694c329c22b00c2a1b54f6f9c2df634f210579b4b6"
    sha256 cellar: :any,                 arm64_big_sur:  "3479376b9b9fecbcfba35b71e367e84d92a6c1e10a93c605ecdf3f21c64ea8b9"
    sha256 cellar: :any,                 monterey:       "4dffaa801df406990c17d3ae92b9896a5e689ae226dcd9aa4293b0c4c105bfcc"
    sha256 cellar: :any,                 big_sur:        "fc1a6ba86fa16ccb06cd0cf444bf074abb618c56a78dc481544117e606fca9e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30244b3c4d3033db671c62a6521578bd2e11a5401458e75eac99fc849d36dbaf"
  end

  depends_on "llvm"
  # Build failure on macOS 10.15 due to `__ulock_wait2` usage.
  # Issue ref: https://github.com/odin-lang/Odin/issues/1773
  depends_on macos: :big_sur

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    # Keep version number consistent and reproducible for tagged releases.
    # Issue ref: https://github.com/odin-lang/Odin/issues/1772
    inreplace "build_odin.sh", "dev-$(date +\"%Y-%m\")", "dev-#{version}" unless build.head?

    system "make", "release"
    libexec.install "odin", "core", "shared"
    (bin/"odin").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["llvm"].opt_bin}:$PATH"
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
