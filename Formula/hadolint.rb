require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.16.0.tar.gz"
  sha256 "148b443b50a8d0c64ac10ca4a50c9b08647d27686279b630c67da395bd2a7e3a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f84a410f8ed431854590e1b19c74256a66df0448088a85796b379070b135684e" => :mojave
    sha256 "dd519c5d307e16452f809001d9a30e03e91c135605d15d8f39b1cd02a206f9cf" => :high_sierra
    sha256 "267c74f211d05f73804643fcefd3175ef640b971ef1b0856217022fa8e248804" => :sierra
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
