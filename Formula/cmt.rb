class Cmt < Formula
  desc "Write consistent git commit messages based on a custom template"
  homepage "https://github.com/smallhadroncollider/cmt"
  url "https://github.com/smallhadroncollider/cmt/archive/0.7.1.tar.gz"
  sha256 "364faaf5f44544f952b511be184a724e2011fba8f0f88fdfc05fef6985dd32f6"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/smallhadroncollider/cmt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2690f2f872ce08413832b0b6fd9e23b384fe7984f2a80e44285edd02d36cbaa5" => :catalina
    sha256 "2f077c726546a39809f627d4d6bb24c0b172252eac7a65139fbcba9b9f1dd296" => :mojave
    sha256 "cbfab965d0ca391ed029d21df3d8da1a21368263b549b65ecf200aa5209d7eba" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "hpack" => :build

  def install
    system "hpack"
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
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
