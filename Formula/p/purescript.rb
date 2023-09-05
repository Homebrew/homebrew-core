class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  # TODO: Try to switch `ghc@9.2` to `ghc` when purescript.cabal allows base>=4.17
  url "https://hackage.haskell.org/package/purescript-0.15.10/purescript-0.15.10.tar.gz"
  sha256 "c12dff938d66cbcd184eaa5fee127679342f14d6243d8195969ed48b26d4ea22"
  license "BSD-3-Clause"
  head "https://github.com/purescript/purescript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "045428ed6c0d93e46a79fa3fa540cffe4af94de79d667cdef5390043b8ea881e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed75c825e3acb3845dae944270e4382026e789b09e86912a0e9ee79fea1e51b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a70b85c4fee0dda2b9eeda7758ea0bf04feb8dbca29d7abf7063fffa192f6a7d"
    sha256 cellar: :any_skip_relocation, ventura:        "855a89536c33efb70c635ff5a466611ef0abf260a9a4b955814ccfb52396244b"
    sha256 cellar: :any_skip_relocation, monterey:       "291ddd60ce776ae02fa046d3f12db72320fce60855b21efb6aafc04d43c34a70"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cecc078307e465933e940450de69acf7f0decca77a97499dd1f723972135f78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c6574c035c301287d56c71a6f60bb5bc3780f4256c75457b0d93711ff9c7157"
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
