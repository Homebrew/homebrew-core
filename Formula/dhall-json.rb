require "language/haskell"

class DhallJson < Formula
  include Language::Haskell::Cabal

  desc "A Dhall to JSON compiler and a Dhall to YAML compiler"
  homepage "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"
  url "https://hackage.haskell.org/package/dhall-json-1.0.0/dhall-json-1.0.0.tar.gz"
  sha256 "514e14a765b0fd360dad7aec62980ca02424d6670be9bf5b9a5a171835a7758d"
  head "https://github.com/Gabriel439/Haskell-Dhall-JSON-Library"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "96f0cdf2a401e36526556d35588d71d763ed7e57ca0f7d7615dfcae3aefe3627" => :sierra
  end

  test do
    (testpath/"testing.sh").write <<-EOS.undent
    #!/usr/bin/env bash
      echo 1 | dhall-to-json
    EOS

    chmod 0755, testpath/"testing.sh"
    assert_match "1", shell_output("./testing.sh")
  end
end
