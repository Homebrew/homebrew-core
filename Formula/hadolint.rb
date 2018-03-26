require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.6.2.tar.gz"
  sha256 "9767c8d6579b7c68d43cac3fb2389cebc9ecc891e89d4408cceef9d5938c2961"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e8192a179b4974874d46c2bbf621b7559cffb068f237d4f63c851c598d21648" => :high_sierra
    sha256 "8d89537863a8e250c76453d34f54351e547f32a82536fec37f7fa760ed185c7c" => :sierra
    sha256 "9fb279e76aecfca33d8ae011357d3efa32296c2bc693c6866e318f01a52efe9a" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.2" => :build

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
