require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.7.1.tar.gz"
  sha256 "c73fbc99546b032e595fc44fc753393d6f0f358952c3d6e9712f09f73d750748"

  bottle do
    cellar :any_skip_relocation
    sha256 "2623c3faf3b1c694758e50d76967c424e9bcb856f2820355c06165c8c5761d71" => :high_sierra
    sha256 "198aae5b47b839709d0cbcb0b61ef73c41207c9610ad76013b25e5080b60922f" => :sierra
    sha256 "def51dd5e44b6aad74894884f9696d301010d6a5c5ad12b5344d94771f3a3d31" => :el_capitan
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
