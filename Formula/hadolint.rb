require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices."
  homepage "http://hadolint.lukasmartinelli.ch/"
  url "https://github.com/lukasmartinelli/hadolint/archive/v1.2.2.tar.gz"
  sha256 "600731b0ebf8b86d561ea7ff37424d3249ccd36b91c440551200829c2f80f646"

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
    # Fix "src/Hadolint/Bash.hs:9:20: error: The constructor 'PositionedComment'
    # should have 3 arguments, but has been given 2"
    # Reported 9 Dec 2016 https://github.com/lukasmartinelli/hadolint/issues/72
    install_cabal_package "--constraint=ShellCheck<0.4.5"
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<-EOS.undent
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
