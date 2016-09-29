require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices."
  homepage "http://hadolint.lukasmartinelli.ch/"
  url "https://github.com/lukasmartinelli/hadolint/archive/v1.2.1.tar.gz"
  sha256 "e0f06adf266f366d8ac847be979ca6db9f16b487f2b1d0d3a2d1db4d1a3e11ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c82de9cd0f6e51c34948c156f73f0b06619ff0d7cd1852584a6f52d23d2bc9b" => :sierra
    sha256 "a100c0b33af09bfc6cebc79d4b77f1297d3af9fe9fd28c0a1b61317f921abdac" => :el_capitan
    sha256 "dd73c444fe18969e280438855416bd2d03cab6f198f43fc8cc83fc03a9a6e7c3" => :yosemite
    sha256 "68f377b99b1245afa10e940059fe22619702f7b9536f85f701afbaa6343a45db" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<-EOS.undent
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
