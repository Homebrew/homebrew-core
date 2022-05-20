class Odin < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin.git",
      tag:      "dev-2022-05",
      revision: "df233aee942bd85a5162a36a82bf33fe74d2f2ad"
  version "2022-05"
  license "BSD-3-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "508b64f49f0b7f182f426e30d16abcc3dff1cdbe708780b93f7262a5f045dc4f"
    sha256 cellar: :any,                 arm64_big_sur:  "797f9d901ac0dacf0378f945ff4cec2de0dd4b3d63af0d0ca1bacb929e314259"
    sha256 cellar: :any,                 monterey:       "df3c2d9d81f53a6c86c9e573ff366136cb0f570f8a99064498d515d894481a6b"
    sha256 cellar: :any,                 big_sur:        "a96a1e8760ad15d81c10c9f7d6dddaaa63db57d76d64446d577fe8491c716aff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3430531b93bb5b6126f3477ce567cd52116f839739bcf19ce337ed1387e08fc3"
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
