require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "http://hadolint.lukasmartinelli.ch/"
  url "https://github.com/lukasmartinelli/hadolint/archive/v1.2.3.tar.gz"
  sha256 "03a342fcb65d86b20ae1728d107344da36ceab87e7e846cb2f802924aa218aac"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4c3729595b2346d96a1a02c19a90a47eb86f9dc4a0dceb7f7dce9abf1f266cb" => :high_sierra
    sha256 "e50b8e3ecbaa931e47a6eef649c041af70569f3812433707e22502cfe281c186" => :sierra
    sha256 "8e2cf9aa35ef51c0ffe475af366a97149b15a64558c97445e34574f6a66ce43d" => :el_capitan
    sha256 "c079436775b7811e6e3b566fa040d9c39580c31e9362fad7386f2527212fde10" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
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
