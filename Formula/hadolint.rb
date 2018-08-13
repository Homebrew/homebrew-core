require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.11.0.tar.gz"
  sha256 "6e637d2e9aad973388183db4e8dc604cdc18c55fcf7271b86296219da08b80a1"

  bottle do
    cellar :any_skip_relocation
    sha256 "116faa9245d892ea1c0b112541cac7966479ab23c2b132fa202234c47279b2e3" => :high_sierra
    sha256 "1076f053ad0b0d78cb61fad472fd3fefa68e57094bd24c490e3c86f9d771c220" => :sierra
    sha256 "59353b788d3c884c0845bc7812fb2b7155cb1ac186d4374c5da7dd08296c8a64" => :el_capitan
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
