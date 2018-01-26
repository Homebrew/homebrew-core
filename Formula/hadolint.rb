require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.3.0.tar.gz"
  sha256 "e3fcd9d2015a4fdef6a5f612560ec862898cdc2c686a7aec32dee90925745bb6"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c56bb5b03587382d42675d89a1cc02bb14d5ab5b72d92c124122aa2f1a4256f" => :high_sierra
    sha256 "2d2274a96a67710ef5550eecd4ab63933f4c16cb68868239a397c181bee97c97" => :sierra
    sha256 "29e604e28d7e9d369321ab7ead7634130810934512208b7abc3227c342460bbb" => :el_capitan
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
