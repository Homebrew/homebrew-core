class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/1.0.0.tar.gz"
  sha256 "14e28d6621d029f027fae44bc4a4ef62c869dab24ff01b88a2e51e6679cbff6c"
  license "Apache-2.0"
  revision 1
  head "https://github.com/haskell/haskell-language-server.git"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "ff41767b9a34b033c176518cefcae7c92beab42a2eb100c5ac98b9ffe27d8c5d"
    sha256 cellar: :any_skip_relocation, catalina: "85c08c2eaa6e16de56173eb17bd3a25d5e7033268ae3215b1ee370931e30998d"
    sha256 cellar: :any_skip_relocation, mojave:   "76a05d6b7ee7ef5f37a308afa8f6cb8a6c5da9f58c50e98c520e7fdae9c152df"
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
        shell_output("PATH=#{ghc.bin}:$PATH #{bin}/haskell-language-server-#{ghc.version} #{testpath}/*.hs", 1)
    end
  end
end
