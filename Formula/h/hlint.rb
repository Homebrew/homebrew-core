class Hlint < Formula
  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.8/hlint-3.8.tar.gz"
  sha256 "a8f236b62be7f28ff2900745a227a29c50b68c9f33c849c678b5c564519bbd74"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1a79fe9800a476c55ea668a9594da108f23635df72bb426d6d3976da27e14ec8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93280e9808e8d43e4d01945354fb77440c661f0b3d92e6686ddc9899212c9799"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "616ff80e2cbaf17bfae3a60fed8ac681f876afa4002f284ac73009763e87aa3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c5a25193ca8218a016a076089372b90c1486c6eeb2277703e5a07c837482c24"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae5cb9e9f135e44bd99b3f244c2e923c7cff19f7eb5dd91216190f113d1761b2"
    sha256 cellar: :any_skip_relocation, ventura:        "4750816681363312e4dbe546ecac8e3c0e73e5d1aa7e9fbe8c32000de864568a"
    sha256 cellar: :any_skip_relocation, monterey:       "a1b46d1026989148f27bc966e2b44b7105101dd79b7632b2ffa008e8732be3eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79daab64b66211cd019e0e6ae9b8a3dacfb4d13831697337f0647837b1b2723e"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build

  uses_from_macos "ncurses"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    man1.install "data/hlint.1"
  end

  test do
    (testpath/"test.hs").write <<~EOS
      main = do putStrLn "Hello World"
    EOS
    assert_match "No hints", shell_output("#{bin}/hlint test.hs")

    (testpath/"test1.hs").write <<~EOS
      main = do foo x; return 3; bar z
    EOS
    assert_match "Redundant return", shell_output("#{bin}/hlint test1.hs", 1)
  end
end
