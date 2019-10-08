require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.17.2.tar.gz"
  sha256 "9ab93b772b9d763ced02717bcf12ad4b060d535f6cdd59cb7b6a23aba61e453b"

  bottle do
    cellar :any_skip_relocation
    sha256 "a14cc819871236cf5c238493e497cc101267224b3ce8d27578622c2bcc926f51" => :mojave
    sha256 "bf080fe17e353dfabe80a060e3379d47fe935994a7a81c3872b0247b5158ee4a" => :high_sierra
    sha256 "5494638c1b68a80e0832eede84bf70afe2ae14c30c80c202e90ca8de9c847009" => :sierra
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
