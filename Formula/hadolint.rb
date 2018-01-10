require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.2.6.tar.gz"
  sha256 "4ae488fd3578d78ee3c258553a9c15c38b21230a35c4c94e46bc1e906e022b88"

  bottle do
    cellar :any_skip_relocation
    sha256 "02aeea324d38e0d926e84c783e234e00ab577fab822c656cb41a8ff7b67f7357" => :high_sierra
    sha256 "00ac30b00f13d64bfc636ebcb713be77e75d3551576eb1ea17abe28f6c95ff9e" => :sierra
    sha256 "09650451882eb4f45e1fd5da4821af9ea1045907692296deb94d1667fa42f7bb" => :el_capitan
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
