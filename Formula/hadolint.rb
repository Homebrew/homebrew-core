require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.10.4.tar.gz"
  sha256 "78c7f3f5494de9c88fd1aa0b86015728cf7215694557818f27a57c7ff906eaab"

  bottle do
    cellar :any_skip_relocation
    sha256 "be846bd545a0c392d2d8c326e0141e5335bba8913cf9a9e0aaa3088fd8ee52a6" => :high_sierra
    sha256 "65af8e62db81ec467ddf74432fbcd349f9c7014b967ccce759f495aff0458ea4" => :sierra
    sha256 "0e223d743e5b86c32900e05246d72e9efe2887dd25a875b478f3d36b520200e9" => :el_capitan
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
