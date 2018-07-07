require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.10.0.tar.gz"
  sha256 "098ad7955683fe833f9c0bad106a47e2e00b2424afcbc7cdcacd6e68af97ebf1"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6aac560de4354c901dd2cc0cbd1d770bcee04ccd0fae3f3090af5ba84c79cce" => :high_sierra
    sha256 "c74be20e61ce997d1931985d8e7f6edb3dfe583093ec373c012f18b437e46367" => :sierra
    sha256 "f330192ce914fcd4f6e7e44ddaf38a8f22a9ba1163152f8a30a35e23667e237e" => :el_capitan
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
