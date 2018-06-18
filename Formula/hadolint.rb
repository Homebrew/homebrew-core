require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.7.4.tar.gz"
  sha256 "f3d13400d6b321e885dde9652d1f15fa54a404cdc5dbad020814acc88abc4d6d"

  bottle do
    cellar :any_skip_relocation
    sha256 "764ec7d799c0169a9fc50b7c85b3926bdf1c3d3dec1dcdce74810947a0fca302" => :high_sierra
    sha256 "9dc0d104436cad8236bd54ca41c2c0e74bb797930dc57e447a2153f0d9c22aba" => :sierra
    sha256 "a71503e8abe54910e79133d18252dfe6724480ddad146e0c47cbef38574f11f7" => :el_capitan
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
