require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "http://hadolint.lukasmartinelli.ch/"
  url "https://github.com/lukasmartinelli/hadolint/archive/v1.2.4.tar.gz"
  sha256 "e8c2051373e029e2e8258a9d5b720edc97e4f980600f7bee2e9acef15502a99c"

  bottle do
    cellar :any_skip_relocation
    sha256 "61393af8a04e698208a9b055811be04d216e50843888343e00d4b5a5da099e01" => :high_sierra
    sha256 "a951547c4fd61d291494592319d9030a18602dca4627384d7ca4c88bb508fa26" => :sierra
    sha256 "c4c7695838ced29657ee3e342a5daccfc45148e284c87bdd0ac10713a3cf6f83" => :el_capitan
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    # Fix "Couldn't match expected type 'CheckSpec'"
    # Reported 18 Dec 2017 https://github.com/hadolint/hadolint/issues/143
    install_cabal_package "--constraint=ShellCheck<0.4.7"
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~EOS
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
