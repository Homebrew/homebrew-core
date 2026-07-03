class Cobra < Formula
  desc "Indentation-based programming language compiled to x86-64 native"
  homepage "https://github.com/Xznder1984/Cobra"
  url "https://github.com/Xznder1984/Cobra/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "7176e63fa39f522651ff50563e3bcf9f25f6251128fa0a10a255b4032459fa35"
  license "MIT"

  head "https://github.com/Xznder1984/Cobra.git", branch: "main"

  depends_on "make" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  def install
    system "make", "build"
    bin.install "cli/bin/cobra"
    bin.install "compiler/bin/cobrac"
    lib.install "runtime/libcobra_runtime.a"
  end

  test do
    system "#{bin}/cobra", "--version"
  end
end
