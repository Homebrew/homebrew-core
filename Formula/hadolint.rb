require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.5.1.tar.gz"
  sha256 "e70e295246193a5b0f2a7d1fc57072ae0e6d5f1178e9fd4cd8abbbb292287f16"

  bottle do
    cellar :any_skip_relocation
    sha256 "8875c7dbaf0a4d497e18c6e4cd8dd124d61696085b5983f30ace76a8233ed6d8" => :high_sierra
    sha256 "06dd733c7653dc2e6e7e14905175c23a0b2edc4451a1c59e3aeec6b1c884b84f" => :sierra
    sha256 "8f78f146eb3d45c79bea4895932f8decb4361bf0dc27564feea6bb7df9b7969d" => :el_capitan
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
