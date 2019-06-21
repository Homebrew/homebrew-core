require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.17.0.tar.gz"
  sha256 "ebb657799abf9c13376ec9b0ab99f2147af27c7a5ebda65d0cac103a35964658"

  bottle do
    cellar :any_skip_relocation
    sha256 "921c4525a11c4748d8a1e9e034769a52b884f8adb00e57226948bd2978c3ee27" => :mojave
    sha256 "ae1ea77bc1dd7324dc3dfb27e5efd3ea9cccc3604c43b96d05b3abd3fbd8bf73" => :high_sierra
    sha256 "9cdbd5e35ed0ccaf6eb2e9dd90b3a3b59c2883fce0977a6e536dc7780907115e" => :sierra
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
