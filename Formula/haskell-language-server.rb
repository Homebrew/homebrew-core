class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/1.5.1.tar.gz"
  sha256 "fa2b1d39d413283202ee1f75e4ad9fc44544535741370d6f1e63afd5878d9e40"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a1af899ccff618cd5461b26b5af64db7361f3626c7a3b63a130eb323ecb7f65"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23e6513586c02b6053e9591c2b111502640742fea5705be5684cd45fe6e77db9"
    sha256 cellar: :any_skip_relocation, monterey:       "27d80ef80a6988cdbde053d39c25fb9461c20811cb109e3592fd2370243d3f6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9f6ee6100f166fb7804dbbc0ed991f1e1e7a93c911c5d2e36c5630a18035e41"
    sha256 cellar: :any_skip_relocation, catalina:       "67da1bed090719a7a37e0bcfc60b8d01d7235adb4b7daea5122c0be17d3131df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3847655ae8f0663df52e1571bda9ba1b5aacc21a14c3b3e4af1e8776cae725ce"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]

  if Hardware::CPU.intel?
    depends_on "ghc@8.6" => [:build, :test]
    depends_on "ghc@8.8" => [:build, :test]
  end

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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

      hls = "haskell-language-server"
      bin.install bin/hls => "#{hls}-#{ghc.version}"
      bin.install_symlink "#{hls}-#{ghc.version}" => "#{hls}-#{ghc.version.major_minor}"
      rm bin/"#{hls}-wrapper" unless ghc == newest_ghc
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
