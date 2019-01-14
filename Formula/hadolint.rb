require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.15.0.tar.gz"
  sha256 "33f59443ffe678784e70ee80b6b482712e3cc0f50685ad6d747cca751a2640fd"

  bottle do
    cellar :any_skip_relocation
    sha256 "00f86e95c8eb2188fd7780487ca9badcedb62bd906bfe0432c35ae16c33d6e4b" => :mojave
    sha256 "df31007a87b66c1ea80948adda8c833e0a4c4260dfd544e7ccc9ff5e2f07d7d8" => :high_sierra
    sha256 "86eac2d1aef96076ab05a587aa3cb03fda35cd1646eee6d44b159b9a71db3ca7" => :sierra
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
