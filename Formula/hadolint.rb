require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.7.3.tar.gz"
  sha256 "6ea73a1d0a7a0f934d2a1427aa1fce0d591fe5a8d1c6bc63ef195f89ae3a7e30"

  bottle do
    cellar :any_skip_relocation
    sha256 "31c5977465e19150786d4dd5f765a7cdf45851d4dfb01b62fe170e07abf77deb" => :high_sierra
    sha256 "f8bdc13bfa2ee6047b1114a731625e18f2d1cd04836a5acbfdc1197a1fb8e4dd" => :sierra
    sha256 "101574d58de8566537a7f0bf0d674893842b67f6a4df91db1871c73a28f8a4a2" => :el_capitan
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
