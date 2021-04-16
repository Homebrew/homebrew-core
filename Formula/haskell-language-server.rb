class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/1.1.0.tar.gz"
  sha256 "1d2bab12dcf6ef5f14fe4159e2d1f76b00de75fa9af51846b7ad861fa1daadb2"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "847e203972e21d930f9ec10d4cdc69773738f9d7c28659e68d5296f504d71544"
    sha256 cellar: :any_skip_relocation, catalina: "445388a5b75b2b3b8ff8e7d484ae7cc45a7ebc99bbe48bca43359aa00681e6e1"
    sha256 cellar: :any_skip_relocation, mojave:   "334831c0ce9b18f14b1b3b93434ba1bd636cd73782ddc55eb6e1464448a481b3"
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
