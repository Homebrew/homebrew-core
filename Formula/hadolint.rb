require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.6.4.tar.gz"
  sha256 "add1d0f1cb1cf18721c6d29add59501545dfe7f5d3d847b6899a114140dfe136"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee9ba9c11e256df89e59eb5eecabd2db68f5695c904dbf300c3128a99aadcb84" => :high_sierra
    sha256 "dcc90bf47d255dc0cfb8613d1611c91b1c1c8ceeff22cd5641a95bb0e02d2a3a" => :sierra
    sha256 "19ea7be134b544b8b289c68243fad88f4d4b9c448c88c20ce5815c5d5c4e040a" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.2" => :build

  def install
    # Fix "The constructor 'PortRange' should have 3 arguments, but has been given 2"
    # Upstream issue from 22 Apr 2018 https://github.com/hadolint/hadolint/issues/195
    inreplace "package.yaml", "language-docker >=3.0.0",
                              "language-docker ==3.0.1"

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
