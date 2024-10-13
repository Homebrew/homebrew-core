class Cryptol < Formula
  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  # ghc 9.10 support request, https://github.com/GaloisInc/cryptol/issues/1737
  url "https://hackage.haskell.org/package/cryptol-3.2.0/cryptol-3.2.0.tar.gz"
  sha256 "ed078965bd7d2468eb403c698374d9525bc2314f9fc53fc7683a7cab5d2ba25b"
  license "BSD-3-Clause"
  head "https://github.com/GaloisInc/cryptol.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a3cd1bc981bbce314d249fcb8ce40de3428e982fef1ec81c442ed53b912352f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "053c643e95edb0e8aed995a5e7909047ceebeb4f53e412aa61e06bc0976d458b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92d6857f01b3e2150a6a00c8893a0c85fada1f7ed00184a17a560b471b8f5b09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f95a9fb6b26ac635b0a3d4542f726ed1a5bae87d1d9b171835ce045ff036765b"
    sha256 cellar: :any_skip_relocation, sonoma:         "304b43329699d57c39fd693b03e7a03f98fbd8a4770d8c3c5419e767ca9db550"
    sha256 cellar: :any_skip_relocation, ventura:        "ee70e56720b01975fd9efde49d877c6948304948277edca15b1cf7e3800717e1"
    sha256 cellar: :any_skip_relocation, monterey:       "17a68673a6921f80e75186a76110027909d99ec92f4e43a2310859cd9b6cb595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f302f1661f45a19b763d4e112ca16f398f4f6be79959ab1501ac65ed52e580c4"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build
  depends_on "z3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"helloworld.icry").write <<~EOS
      :prove \\(x : [8]) -> x == x
      :prove \\(x : [32]) -> x + zero == x
    EOS
    expected = /Q\.E\.D\..*Q\.E\.D/m
    assert_match expected, shell_output("#{bin}/cryptol -b helloworld.icry")
  end
end
