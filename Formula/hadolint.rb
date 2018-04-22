require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.6.5.tar.gz"
  sha256 "0e15c1615d2895ae4367d77b40771e16c2b5bd4d0fb26971fd67729da11836b4"

  bottle do
    cellar :any_skip_relocation
    sha256 "a83ac4d38d4cf25662030d91f41fc3da899142829945f421667e084c21080235" => :high_sierra
    sha256 "a6da7db6afeeb8b98a160149f1ada17c67ad88b45b198cbf92d8e334a0ac3e40" => :sierra
    sha256 "f1e4240cabbc049002a462fbeb5b9a5901ccdac8c39cbcd225f77dff7b3df942" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.2" => :build

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
