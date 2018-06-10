require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.7.1.tar.gz"
  sha256 "c73fbc99546b032e595fc44fc753393d6f0f358952c3d6e9712f09f73d750748"

  bottle do
    cellar :any_skip_relocation
    sha256 "0aba1af7a2d0eeda3bde03548d47cf92180d1791dddbb53e3cf4f35b6dcbedb3" => :high_sierra
    sha256 "df8c6614c2bbdee05a91d93ce95707d4252a6d14d8fa655ea7ca7d48505e6239" => :sierra
    sha256 "7835061a094734eee3854e223855fc59e0fd0773d27f03bd4ccfc60f53497b32" => :el_capitan
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
