class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/1.1.0.tar.gz"
  sha256 "db1070151fb3c1ac94a7b07064de3d4d499a741fd96300b08559e08c62544618"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "47d2d91481d71d30b47ac0128c2bf8a7c557ce5b67ee09d0db2326a0b262979b"
    sha256 cellar: :any_skip_relocation, catalina: "b17ea0a22d8cd9423fead6749ded2ee55ec046cfb53cb5d898f952591acd627d"
    sha256 cellar: :any_skip_relocation, mojave:   "fa48dc85175a73df20c51fdd32efdf39e5e95a35e19ad1ee41ead929bc260bcf"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]
  depends_on "ghc@8.6" => [:build, :test]
  depends_on "ghc@8.8" => [:build, :test]

  def install
    system "cabal", "v2-update"

    %w[ghc@8.6 ghc@8.8 ghc].each do |ghc_str|
      ghc = Formula[ghc_str]

      system "cabal", "v2-install", "-w", ghc.bin/"ghc", *std_cabal_v2_args

      bin.install bin/"haskell-language-server" => "haskell-language-server-#{ghc.version}"
      rm bin/"haskell-language-server-wrapper" unless ghc_str == "ghc"
    end
  end

  def caveats
    ghc_versions = [
      Formula["ghc@8.6"].version,
      Formula["ghc@8.8"].version,
      Formula["ghc"].version,
    ].join ", "

    <<~EOS
      #{name} is built for GHC versions #{ghc_versions}.
      You need to provide your own GHC or install one with
        brew install ghc
    EOS
  end

  test do
    valid_hs = testpath/"valid.hs"
    valid_hs.write <<~EOS
      f :: Int -> Int
      f x = x + 1
    EOS

    invalid_hs = testpath/"invalid.hs"
    invalid_hs.write <<~EOS
      f :: Int -> Int
    EOS

    %w[ghc@8.6 ghc@8.8 ghc].each do |ghc_str|
      ghc = Formula[ghc_str]

      assert_match "Completed (1 file worked, 1 file failed)",
        shell_output("PATH=#{ghc.bin}:$PATH #{bin}/haskell-language-server-#{ghc.version} #{testpath}/*.hs 2>&1", 1)
    end
  end
end
