require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.10.1.tar.gz"
  sha256 "9164b4dd44be6a02c7416258cb1ce3574117d4ca06b65676955f2bbe02bb62aa"

  bottle do
    cellar :any_skip_relocation
    sha256 "95ff6f1f66ff589052a576f6d2364f5bee3ace9e71bac544e8039de3fe053fe6" => :high_sierra
    sha256 "0a556d120fc9073cdb018854edd6d244e9dd2b03b339ec8984facef447dc7475" => :sierra
    sha256 "f39f4d9862991aaeb7a348f4e5587a72a7c034a64e91be25acfa34a47677dd50" => :el_capitan
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
