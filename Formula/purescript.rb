class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  url "https://hackage.haskell.org/package/purescript-0.14.9/purescript-0.14.9.tar.gz"
  sha256 "edfb8343e7b7699cb4a474c5de2b1eeafdf7cd020879546244c6ec1212b48a8d"
  license "BSD-3-Clause"
  head "https://github.com/purescript/purescript.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bbf475e4d52b79b7b015bfae45160e303082642ad9406bcb652455d1d017bc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f9698670433bf5c1d8aa4d13d9b0cf64761d04ff5d21995da6254262643f25e"
    sha256 cellar: :any_skip_relocation, monterey:       "4e6c05e70eb867336d74ec1100dadf47cff5573cf1fe96ea8f538ec61097f16f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4207c2283e0e40c926847cee5ad850f2786b35030bde0ea10ae108e703564d4e"
    sha256 cellar: :any_skip_relocation, catalina:       "48d59e3776e043156cfd7a92055fdf25a15c8a65dc268c89ebfff0ef385d7a0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c807a7d5d25dc482fd20ce652238ee869d5d41ed413ecb52d1ca6d7bb584cda9"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "purescript-cst" do
    url "https://hackage.haskell.org/package/purescript-cst-0.5.0.0/purescript-cst-0.5.0.0.tar.gz"
    sha256 "ede84b964d6855d31d789fde824d64b0badff44bf9040da5826b7cbde0d0ed8d"
  end

  def install
    (buildpath/"lib"/"purescript-cst").install resource("purescript-cst")
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
