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
    sha256 cellar: :any,                 monterey:     "f24379e907c9f66dcf9bf07327499982194ea03cc95a3c8ce4029f728bbcfbe8"
    sha256 cellar: :any,                 big_sur:      "8756628900882ce7b6492cd63a16192c66420c792c4ae6bc625104f10cd4ad91"
    sha256 cellar: :any,                 catalina:     "a3ae074bcf9f1b096fd0ff73ec3e4169580cbd9c992eaf96df00381fb4bc4aab"
    sha256 cellar: :any,                 mojave:       "4f2a22f846642e17dd24a44ec9bd5e00a768facbeba1ea76f2b528f1407c6669"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1a2aed348bd038115e6581e293a69291eca7a2ef89a59589faf36d9ed81089d1"
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
