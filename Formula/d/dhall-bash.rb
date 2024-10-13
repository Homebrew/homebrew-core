class DhallBash < Formula
  desc "Compile Dhall to Bash"
  homepage "https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-bash"
  url "https://hackage.haskell.org/package/dhall-bash-1.0.41/dhall-bash-1.0.41.tar.gz"
  sha256 "2aeb9316c22ddbc0c9c53ca0b347c49087351f326cba7a1cb95f4265691a5f26"
  license "BSD-3-Clause"
  head "https://github.com/dhall-lang/dhall-haskell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d52349786b0b0288928a07f34495eaabb606b50478be372661aa32dca3a53d5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6932266f568e291768e86c3e995c625d9295a6b5aa6e0509694b64da1befe55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2228d77b18593f1d2e2e0a382d3668716e5c002a4ac2354047ca6dcbbae327c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5effd1de6bb963135bfe8335d5e3ef54dcb2fcb7867b2aa47a15df248dc57214"
    sha256 cellar: :any_skip_relocation, sonoma:         "f33bd2e5fb093aad3b961486d55a9616d43e7411452242863babd5973e95d9c7"
    sha256 cellar: :any_skip_relocation, ventura:        "52af086896ca9903342a123aa91ef7fdff9b76e8a3bf6827eba53bd6cc78817e"
    sha256 cellar: :any_skip_relocation, monterey:       "46dc888d21b56242ba9f076b07379e351858bf88a0bd5b896c5cc93dca87b7f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd6520e32209110b00b6a9aad89cd4217b93f367140cbe870206c117d22027ed"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    cd "dhall-bash" if build.head?
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match "true", pipe_output("#{bin}/dhall-to-bash", "Natural/even 100", 0)
    assert_match "unset FOO", pipe_output("#{bin}/dhall-to-bash --declare FOO", "None Natural", 0)
  end
end
