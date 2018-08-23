require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.11.2.tar.gz"
  sha256 "39a436fe8723bc9b2ae66b1ca24d227b4ec275e033902465b7179223581955f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba16f38d6c2c0bd47cafd945354b9627f2a5c0134c6341d96b0e5f8abada813f" => :mojave
    sha256 "703ad4d3e8d8b95e9a876f256f1b5e3532e134f61e0384a4527fb891e83bd778" => :high_sierra
    sha256 "e058f23eea78c7a82ac30f095dfc18c1f187eef12fb8d19d3f3f3d518cd14be1" => :sierra
    sha256 "c65d400c2d4725161cf548ed1aa6c98f998ad6ff52271348bf85868ebb820f84" => :el_capitan
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
