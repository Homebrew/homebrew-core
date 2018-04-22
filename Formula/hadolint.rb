require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.6.4.tar.gz"
  sha256 "add1d0f1cb1cf18721c6d29add59501545dfe7f5d3d847b6899a114140dfe136"

  bottle do
    cellar :any_skip_relocation
    sha256 "a83ac4d38d4cf25662030d91f41fc3da899142829945f421667e084c21080235" => :high_sierra
    sha256 "a6da7db6afeeb8b98a160149f1ada17c67ad88b45b198cbf92d8e334a0ac3e40" => :sierra
    sha256 "f1e4240cabbc049002a462fbeb5b9a5901ccdac8c39cbcd225f77dff7b3df942" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.2" => :build

  def install
    # Fix "The constructor 'PortRange' should have 3 arguments, but has been given 2"
    # Upstream issue from 22 Apr 2018 https://github.com/hadolint/hadolint/issues/195
    inreplace "package.yaml", "language-docker >=3.0.0",
                              "language-docker ==3.0.1"

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
