class Cryptol < Formula
  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "https://www.cryptol.net/"
  # TODO: Try to switch `ghc@9.2` to `ghc` when cryptol.cabal allows ghc-bignum>=1.3
  url "https://hackage.haskell.org/package/cryptol-3.0.0/cryptol-3.0.0.tar.gz"
  sha256 "844660c6a85170f3765161e15e8719c637d96b9c292f96bd455b4cb18dc5d54f"
  license "BSD-3-Clause"
  head "https://github.com/GaloisInc/cryptol.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddf4bba413e84315ecd219d131254e81c98c1880f0c152d175ea8d1e0cd75f60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb37d4c49186b2427fa22db9d81bc4faeb2d0586ac31285ef88ad337f1604eef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a012d46f5209d1a245201fc99f80679b9624c0ab74379af954e9e0901f4aa48"
    sha256 cellar: :any_skip_relocation, ventura:        "a75dd102d569cafbfc76ffa8f02da6764c803929a87145db184e047289ebf8fc"
    sha256 cellar: :any_skip_relocation, monterey:       "2773787758a94f584f1c083b7efb7c131ee3205a718536cca9b5e040871b7ea9"
    sha256 cellar: :any_skip_relocation, big_sur:        "f241ace085d5fea00472b96ce5e179bbf72dbeb1369d1f4ec2ddca46ab5de729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e99cb2894034d48e93746bab719bebcb37b0695e53d5302e1fc3a72912f4d69"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.2" => :build
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
