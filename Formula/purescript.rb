class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  url "https://hackage.haskell.org/package/purescript-0.14.3/purescript-0.14.3.tar.gz"
  sha256 "2a82532d416d93d117ab942ab0b618642d788bf0dae09fc045bc1cc88ba71f3c"
  license "BSD-3-Clause"
  head "https://github.com/purescript/purescript.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1396d1c16143ed7e3c362ae15637826bbe9300aa66e977b453cb30a743aa3b59"
    sha256 cellar: :any_skip_relocation, big_sur:       "6852d9fbbebd8cc8511cb2c97b0f77606cda026f397e1790cf216a6bcacedc6b"
    sha256 cellar: :any_skip_relocation, catalina:      "a79c6ce5756e2e67a158746d00eccc20e2b219f83d6a11beb4dcb53f84d99dd3"
    sha256 cellar: :any_skip_relocation, mojave:        "6e3bf108982f98270f201e4ef67e3533e3c57b932656f4b8ee187d756efd2541"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "purescript-cst" do
    url "https://hackage.haskell.org/package/purescript-cst-0.3.0.0/purescript-cst-0.3.0.0.tar.gz"
    sha256 "c23ba1ef0714ff59c9e4bc7a74531f5e1422ebf616bdc3cbe9f6597cbb1bee95"
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
