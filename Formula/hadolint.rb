require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.7.4.tar.gz"
  sha256 "f3d13400d6b321e885dde9652d1f15fa54a404cdc5dbad020814acc88abc4d6d"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6a77b6b7136871c00b2770b6e887dee33639b1b3e57877c1964b42aa4115e46" => :high_sierra
    sha256 "5fac05e6a44b5b25902d1333daa78023001db00b2a3f0a07e03824f3ad04dcd5" => :sierra
    sha256 "e9dc5fb17c8fb65ab85dc23deb92319db55155583cd066ce78d153eca1263c0e" => :el_capitan
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
