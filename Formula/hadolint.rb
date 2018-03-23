require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.6.1.tar.gz"
  sha256 "bf78ec648de0da76f20613eaa587fc81b64911124f460b42ee98ddf1a384aa70"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d676a969ef6182c30fd79f0e564e5559bd24045f080cd3033c07b809f8e9f26" => :high_sierra
    sha256 "69e2d59d5073ad21503e754df3f86b8fc71d36a62ea3e2b70d9131a3c3518f97" => :sierra
    sha256 "a4f347e363cf7c8a1defd1da449390c4f39888f30ca2806c0ec5ee2ffb56b6c1" => :el_capitan
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
