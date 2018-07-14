require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.10.3.tar.gz"
  sha256 "056cd2413a00d9ae7094b5916d3dfa010ca3a11d249ed247af5894b08ad91506"

  bottle do
    cellar :any_skip_relocation
    sha256 "9fa99881e10bfa2eedf58499c24019ccbd852fa3587f4c0e27136ea9439fb071" => :high_sierra
    sha256 "55a7839b8017da825d99ccbd7438944af7f5646d4f9815dfab3ff45a9e733c40" => :sierra
    sha256 "4bd592f5d2e0597c6a26d56dbe771474a7e7c4b5dc834f189ed106228536f1ff" => :el_capitan
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
