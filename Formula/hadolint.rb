require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.6.2.tar.gz"
  sha256 "9767c8d6579b7c68d43cac3fb2389cebc9ecc891e89d4408cceef9d5938c2961"

  bottle do
    cellar :any_skip_relocation
    sha256 "e62a9df8357e01bb926bb5704d11941a48b9fdb2752838ef8a749b6fcdce75f6" => :high_sierra
    sha256 "40a74bc9e04828c03f272915eeddec2a5deaa886aac5f4c6736a7089e3af41b3" => :sierra
    sha256 "3574a3298c616f68428bfd2dffe193d4f397fea49cfee3706fcc02998ed8609d" => :el_capitan
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
