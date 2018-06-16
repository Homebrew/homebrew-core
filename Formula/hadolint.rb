require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.7.3.tar.gz"
  sha256 "6ea73a1d0a7a0f934d2a1427aa1fce0d591fe5a8d1c6bc63ef195f89ae3a7e30"

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
