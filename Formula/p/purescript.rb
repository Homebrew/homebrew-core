class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  # TODO: Try to switch `ghc@9.2` to `ghc` when purescript.cabal allows base>=4.17
  url "https://hackage.haskell.org/package/purescript-0.15.12/purescript-0.15.12.tar.gz"
  sha256 "1f3724689e4a4bb8c89fbc9bd0ccdd28ccb49c36730b19547bb39f791ea65467"
  license "BSD-3-Clause"
  head "https://github.com/purescript/purescript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "005dc62acebf292c4f7e023580c429ebcc61615129bf76ca54db740a6a69305a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "054334032e489ad163a10fdbd86ff76dddcbab0307d9082a42105d83d073bda6"
    sha256 cellar: :any_skip_relocation, ventura:        "ae452361dffe0903c1405b029526acdba1ec68aeb5d5c8f3ed993b764ed73a2c"
    sha256 cellar: :any_skip_relocation, monterey:       "be87b2b30dd76027f7f37721980641ee6193f772300e48c826fce3f0f330c921"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e56e4829b4145abd71ee74592460efc2e1b55f212d88af96a96b8a60171f63d8"
  end

  depends_on "ghc@9.2" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # Use ncurses in REPL, providing an improved experience when editing long
    # lines in the REPL.
    # See https://github.com/purescript/purescript/issues/3696#issuecomment-657282303.
    inreplace "stack.yaml", "terminfo: false", "terminfo: true"

    system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"
  end

  test do
    test_module_path = testpath/"Test.purs"
    test_target_path = testpath/"test-module.js"
    test_module_path.write <<~EOS
      module Test where

      main :: Int
      main = 1
    EOS
    system bin/"purs", "compile", test_module_path, "-o", test_target_path
    assert_predicate test_target_path, :exist?
  end
end
