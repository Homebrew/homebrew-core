require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.12.0.tar.gz"
  sha256 "ce5e87d15849d47e31ac55c4dec2c368c73ba733438883a505957c6dc3015509"

  bottle do
    cellar :any_skip_relocation
    sha256 "79157bd9109e9b73d45aca40f994982af3caa7ca04edc4ed97676849aa9f2553" => :mojave
    sha256 "cc3a789eb57adda003470d8cf785376af3a5c70f6835c2a3d22b0ec6c4e5c5d5" => :high_sierra
    sha256 "df9103ad993fe0864f420cc55f7f1c3311297859dcbdbc4c487a26fa2cc33735" => :sierra
    sha256 "d03344b9b87e12d6dbde2c1e1b114fc82093d762273bff8b9df0a90bd5afa8e4" => :el_capitan
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
