require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.10.1.tar.gz"
  sha256 "9164b4dd44be6a02c7416258cb1ce3574117d4ca06b65676955f2bbe02bb62aa"

  bottle do
    cellar :any_skip_relocation
    sha256 "00ff858ce3d2005bfd5a9eb31cd22f3d7927795c08d2cee410049f8e37079709" => :high_sierra
    sha256 "d09ccdd4b5e7b2d8649dc4cf3efa38f7e1b4c08fba928cd0f9a32926a68c37b9" => :sierra
    sha256 "84e6cbd45c8747e999d10484d35fa34e0c03836e599c9472fb310fa6a2b50265" => :el_capitan
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
