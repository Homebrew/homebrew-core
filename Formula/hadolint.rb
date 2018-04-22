require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.6.5.tar.gz"
  sha256 "0e15c1615d2895ae4367d77b40771e16c2b5bd4d0fb26971fd67729da11836b4"

  bottle do
    cellar :any_skip_relocation
    sha256 "f02373bd57672a478c6591c86127c6b242eee1323ee7df7f45e76698ae3dbd32" => :high_sierra
    sha256 "97c4e21204f20579855db768ff375e85cbdbf73f3d8c2cd5bd988f6cf7878b2b" => :sierra
    sha256 "39fa72ce2e40e58511ec0101b58fd6bebd29d9ef4d431b4f8c2fd6de94dbff66" => :el_capitan
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
