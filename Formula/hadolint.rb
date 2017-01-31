require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices."
  homepage "http://hadolint.lukasmartinelli.ch/"
  url "https://github.com/lukasmartinelli/hadolint/archive/v1.2.2.tar.gz"
  sha256 "600731b0ebf8b86d561ea7ff37424d3249ccd36b91c440551200829c2f80f646"

  bottle do
    cellar :any_skip_relocation
    sha256 "e50b8e3ecbaa931e47a6eef649c041af70569f3812433707e22502cfe281c186" => :sierra
    sha256 "8e2cf9aa35ef51c0ffe475af366a97149b15a64558c97445e34574f6a66ce43d" => :el_capitan
    sha256 "c079436775b7811e6e3b566fa040d9c39580c31e9362fad7386f2527212fde10" => :yosemite
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
