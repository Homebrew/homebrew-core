class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  url "https://hackage.haskell.org/package/purescript-0.15.6/purescript-0.15.6.tar.gz"
  sha256 "75bc618d1db6ce7f96db9fed26029e450718a1db66f8921ee1856d73ec97e8a6"
  license "BSD-3-Clause"
  head "https://github.com/purescript/purescript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b54a5c3a58dc97a2a87bf633c8a556165543f4af7e5e36775283f599f58f5e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89000bbdbea995ae9109d0846daf4e8959fa8e0ac7868b03ea0c627c6c23c6d7"
    sha256 cellar: :any_skip_relocation, ventura:        "50ed65494255c005d3a4f9bd9eee13ea87ba4cfd96a97b15513e958a34432bbf"
    sha256 cellar: :any_skip_relocation, monterey:       "325cefc0ea682cd30dc6e034bca02c79595d03e268cacfa95a5e0ceed6c38f4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f47f53bb001cba93513e33fc1c3aac8e931924e2f54bffbeeeca4d6f6e2e7e94"
    sha256 cellar: :any_skip_relocation, catalina:       "9989547c19a0e4959d658819880349374d2d8f09f311ec30c7af62518e3c0bc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d9ea1019c81d595ec7ea8d78fc484f28a49999e4388dc123aec6b1337822bc8"
  end

  depends_on "ghc" => :build
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
