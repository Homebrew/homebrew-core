require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.17.1.tar.gz"
  sha256 "5af367baaec97a41058031b1c3046a714cacdaf33b1d8a86ac23f4c53cb6d866"

  bottle do
    cellar :any_skip_relocation
    sha256 "8fe98c963316de24d6e2f796e034b208194b2aa5a478445449fe3ed899b3d79e" => :mojave
    sha256 "4d4224a8d1d9ada58f359066f54184f2a498df2373c01471f5d8e900f6383a72" => :high_sierra
    sha256 "803e4bc64d480e4419f7a5bbb393ec6e6b85e3a9b25cae834c78d991ff54bad8" => :sierra
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
