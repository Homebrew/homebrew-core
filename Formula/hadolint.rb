require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.10.4.tar.gz"
  sha256 "78c7f3f5494de9c88fd1aa0b86015728cf7215694557818f27a57c7ff906eaab"

  bottle do
    cellar :any_skip_relocation
    sha256 "972c3c104e74207c3bcc29ac2fe6fc957dee59e4e6af2afbf4eda85de60688d2" => :high_sierra
    sha256 "9fb84af093f5176a9b8a3fa2573352fcc1cc40fd083d0d75c186779f7bbaf99b" => :sierra
    sha256 "47377a69898cf72a91e8fce465bcd127f9f15b4ceba81b888de17b6f8f92c7e8" => :el_capitan
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
