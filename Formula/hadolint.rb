require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "http://hadolint.lukasmartinelli.ch/"
  url "https://github.com/lukasmartinelli/hadolint/archive/v1.2.4.tar.gz"
  sha256 "e8c2051373e029e2e8258a9d5b720edc97e4f980600f7bee2e9acef15502a99c"

  bottle do
    cellar :any_skip_relocation
    sha256 "95731202fdc25da1ce4f56fcc7ef1c0cd5e729bb07d7edbe8908bdcea5423770" => :high_sierra
    sha256 "74f74eb4f0e3a9a07873d0f3d3eb1760ae38dd7b07835f447b93ca4789066dbb" => :sierra
    sha256 "8d2d5f0f9a65940f41bc0f537c0c0ae23436486fd14ed2786fa267b84f8e69fc" => :el_capitan
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    # Fix "Couldn't match expected type 'CheckSpec'"
    # Reported 18 Dec 2017 https://github.com/hadolint/hadolint/issues/143
    install_cabal_package "--constraint=ShellCheck<0.4.7"
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~EOS
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
