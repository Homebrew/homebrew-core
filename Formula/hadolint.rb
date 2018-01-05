require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.2.5.tar.gz"
  sha256 "ad2a85e0c3908642632023745f834879a806799bbfe8888fb561cdb5ec97a015"

  bottle do
    cellar :any_skip_relocation
    sha256 "49ffce3240461b6f3dfaad58163e74498c57bf10c264218a6fec121cbb47bf9c" => :high_sierra
    sha256 "fe6f26e6999e2951b23f9954d1aa9e926c36c49ea393b6b0f4d6273327c138ae" => :sierra
    sha256 "92a75bbb458e444183bb4787d6afed88589a0f3777f5e094052ab1c789568d68" => :el_capitan
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

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
