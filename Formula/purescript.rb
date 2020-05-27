class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  url "https://hackage.haskell.org/package/purescript-0.13.8/purescript-0.13.8.tar.gz"
  sha256 "701fac49de867ec01252b067185e8bbd1b72e4b96997044bac3cca91e3f8096a"
  head "https://github.com/purescript/purescript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9ae94071a81b727b303b9030db5bba1e6bdd62d9197f11792b36c63c24ea8f4" => :catalina
    sha256 "722db0bdf3894e87af760e1f04e1ac1c450d9e522c104471457b04675b07f62c" => :mojave
    sha256 "9daf0153a5ad5ae5a99030416c6d7f8cf6fb13f16aef52823f1d0c9f7682d6da" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  depends_on "hpack" => :build if build.head?

  def install
    system "hpack" if build.head?

    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
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
