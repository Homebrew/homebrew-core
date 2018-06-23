require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.7.5.tar.gz"
  sha256 "a710192542f4ff0402fec91b3a1c80461867331704ef7647293aed6a382c4c60"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b23669815f0647b886874a2e1d55554e99fddc5ab5dd980f5c5bb39e4d8a4a6" => :high_sierra
    sha256 "f300c3c13f5cd4205623ef946e29a5da4ad8b85d713e615f97cfcfd8750530b8" => :sierra
    sha256 "4ef37aa21989ca6eb6e4d01dbb17563cc0c0d768f23621f4087e3981dccd3ff8" => :el_capitan
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
