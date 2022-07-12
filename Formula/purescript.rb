class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  url "https://hackage.haskell.org/package/purescript-0.15.4/purescript-0.15.4.tar.gz"
  sha256 "df279079a7c78c5b1fa813846797e696787f5dd567b1b6e042f7ab6a2701868f"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/purescript/purescript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbb56b419ea3b2cda52e0fc16e1d0b97db046152e9a8408e28d537c17cb33e03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af79f109e8ef0828b2d80c877e8a7975c191c292b37ee53b0b35422219d18210"
    sha256 cellar: :any_skip_relocation, monterey:       "d08310c0f880acd361311f080d16b4f8514c512a01846291fb299bb4d7d93094"
    sha256 cellar: :any_skip_relocation, big_sur:        "bff0a0549513ff689902ae7f730b200df972e7d3735a5e1a7b66b2dd583acb2e"
    sha256 cellar: :any_skip_relocation, catalina:       "839bfa5da0655f4fdf30d14c504be2889bda8171582015aaa2d4a1eb561853ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc2465cf615ab118100e27dbc6d71d8bca73b518c047d62bae5f7b7792a8fdfd"
  end

  depends_on "ghc@9" => :build
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
