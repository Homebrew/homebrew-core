require "language/haskell"

class Cmt < Formula
  include Language::Haskell::Cabal

  desc "Write consistent git commit messages based on a custom template"
  homepage "https://github.com/smallhadroncollider/cmt"
  url "https://github.com/smallhadroncollider/cmt/archive/0.7.1.tar.gz"
  sha256 "364faaf5f44544f952b511be184a724e2011fba8f0f88fdfc05fef6985dd32f6"

  bottle do
    cellar :any_skip_relocation
    sha256 "000379960e116751b0b65db8323729cde8e4b524f2ec956246a494f2c4a1e676" => :catalina
    sha256 "9119f6838dd3172aae1e145f43dc34f78ab4d8f8e8e6c72927d404211e73ae2b" => :mojave
    sha256 "abd7fab4e32cdc50f8ec4c84c84bb8cb0001b21a3e4199dcb848fc3270298297" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "hpack" => :build

  def install
    system "hpack"
    install_cabal_package
  end

  test do
    (testpath/".cmt").write <<~EOS
      {}

      Homebrew Test: ${*}
    EOS

    expected = <<~EOS
      *** Result ***

      Homebrew Test: Blah blah blah


      run: cmt --prev to commit
    EOS

    assert_match expected, shell_output("#{bin}/cmt --dry-run --no-color 'Blah blah blah'")
  end
end
