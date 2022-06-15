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
    sha256 cellar: :any,                 arm64_monterey: "506cf50feb10db57f679850c4e1b046c8d5cb320cf849742990e51a056686557"
    sha256 cellar: :any,                 arm64_big_sur:  "a1841da7e51c016c45b7d24b47a763873ade6cc33be56dec7568f3bab7fc9f13"
    sha256 cellar: :any,                 monterey:       "6dfb144248a30dc5ea62b78adba57e890a8c56308928712e7784170fd057262d"
    sha256 cellar: :any,                 big_sur:        "755a3411b972a3108ff3bc028e41e84969258ca057eb22be705a39f112567bb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "539cc1ef40a4c81911836b05adc67f0b20cfa5ad9a0aae70a2a735b718c0e72b"
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
