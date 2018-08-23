require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.11.2.tar.gz"
  sha256 "39a436fe8723bc9b2ae66b1ca24d227b4ec275e033902465b7179223581955f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "926fb9a06487f10e17ff1eebb69540d19b23a68566e1b593250efcf8d52a05fa" => :high_sierra
    sha256 "678ee84e55541833119a0d8580b1b9602e4817491102d9fdc274964bbfdcf50a" => :sierra
    sha256 "9129a9e1502000394d27e8820ab673d004dffd9c877b3c415487d2bed24c1195" => :el_capitan
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
