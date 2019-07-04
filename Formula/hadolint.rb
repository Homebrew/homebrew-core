require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.17.1.tar.gz"
  sha256 "5af367baaec97a41058031b1c3046a714cacdaf33b1d8a86ac23f4c53cb6d866"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9025b690566166a639cd7206cf9cc13e6682140d6300557a3c8a610591822d2" => :mojave
    sha256 "16e592ead47095b90c38ba4013728cf5dd3cab015e863785b1de911a4a964b32" => :high_sierra
    sha256 "8356b2cbd9b8f968fe98ff3971182891e05406a978b80bf9b4f41d0602702ba8" => :sierra
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
