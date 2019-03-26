require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.16.2.tar.gz"
  sha256 "acbc057a1eb8367ff13ec86c4e5b2eb6fa66f9536bf4716648e2108163fca9c6"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d93806a8a4ed05e4234cbcab8b7fbbac06d5eb40e8fe24cd56ca8f4ffdaa836" => :mojave
    sha256 "2e9dfbd2e39689eb5a0240d0d967ed0be8e7a72fb27e8aab9dd606bb332b3c63" => :high_sierra
    sha256 "bc3a05382f66059eab138cac77c1af2e717f4becb91e5de558d1c4e8672b40da" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    cabal_sandbox do
      cabal_install "hpack"
      system "./.cabal-sandbox/bin/hpack"
    end

    install_cabal_package
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~EOS
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
