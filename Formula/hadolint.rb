require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.5.0.tar.gz"
  sha256 "ea67439c3b785219905a24e9c66185ebaabbfb6cc0a088142d93f34bb30e61b5"

  bottle do
    cellar :any_skip_relocation
    sha256 "421424b317e3b85d1dda24ee6897dcdda4de4297ad42d3709cecc1f4b643fa0e" => :high_sierra
    sha256 "4d4b119e0876a0c31397b26b784d525f456d3a119deb3178b3a53ca9d5fd7561" => :sierra
    sha256 "733445a8e4b549a0531c278853ade0a63fd3f992cee472142d38539f7b6ace9e" => :el_capitan
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
