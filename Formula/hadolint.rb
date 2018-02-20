require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.5.0.tar.gz"
  sha256 "ea67439c3b785219905a24e9c66185ebaabbfb6cc0a088142d93f34bb30e61b5"

  bottle do
    cellar :any_skip_relocation
    sha256 "8be112fb9b1416d21bdbb0683962424219c50fecbda8c46a0451546c5b18fdbb" => :high_sierra
    sha256 "9166a7eab00cf8253a9a3b9629699f67b56fe93c526f0f9ac0dc3cfa873a5afc" => :sierra
    sha256 "b658493b6da9d99941b1c8479a0ee7b8ddb0c006dbaf49dee922f44ff8cbe9b0" => :el_capitan
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

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
