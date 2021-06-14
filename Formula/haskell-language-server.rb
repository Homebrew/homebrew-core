class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/1.2.0.tar.gz"
  sha256 "8931fd95bf28300d3f18675b0f03aac9bda172becb67eaa8ef1f62e6d1c6238e"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d4469d0540ea72012e40881286e3479f067a2367e9eea8401e1405523dd22f60"
    sha256 cellar: :any_skip_relocation, big_sur:       "cfb60a5fff37ea3f94be9ec63168319ef40fafa10558a365b7a8be4e0fe74d76"
    sha256 cellar: :any_skip_relocation, catalina:      "9a7335c96c9b5f75d8ab0d1229d8031794a066c4a429163f5e952d2f7a77a2f2"
    sha256 cellar: :any_skip_relocation, mojave:        "5e4337b8fbceb61242f96e7b120fd30d1d7b1cfc19e017d1aa922e08137f4e00"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]

  if Hardware::CPU.arm?
    depends_on "llvm" => :build
  else
    depends_on "ghc@8.6" => [:build, :test]
    depends_on "ghc@8.8" => [:build, :test]
  end

  def ghcs
    deps.map(&:to_formula)
        .select { |f| f.name.match? "ghc" }
        .sort_by(&:version)
  end

  def install
    system "cabal", "v2-update"
    newest_ghc = ghcs.max_by(&:version)

    ghcs.each do |ghc|
      system "cabal", "v2-install", "-w", ghc.bin/"ghc", *std_cabal_v2_args

      bin.install bin/"haskell-language-server" => "haskell-language-server-#{ghc.version.major_minor}"
      rm bin/"haskell-language-server-wrapper" unless ghc == newest_ghc
    end
  end

  def caveats
    ghc_versions = ghcs.map(&:version).map(&:to_s).join(", ")

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

    ghcs.each do |ghc|
      with_env(PATH: "#{ghc.bin}:#{ENV["PATH"]}") do
        assert_match "Completed (1 file worked, 1 file failed)",
          shell_output("#{bin}/haskell-language-server-#{ghc.version.major_minor} #{testpath}/*.hs 2>&1", 1)
      end
    end
  end
end
