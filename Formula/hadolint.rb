require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.9.0.tar.gz"
  sha256 "84ae0d50573ff93dc6e444488bacfda57007d9823271a363cd682ecc8b89199e"

  bottle do
    cellar :any_skip_relocation
    sha256 "f693381e32fee6fbbb8ebc213d6c20098e512b086a8afcd90ebb6413b4f511e7" => :high_sierra
    sha256 "64a3604847d1b0b6d91f5394ebceeae54a169f24c0f1987da83ed171ae3f6087" => :sierra
    sha256 "74393bea34cd4a6df62bfb6e39791c9ba95be38ffef94ed5b29c040705ce0c07" => :el_capitan
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
