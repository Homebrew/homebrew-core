class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/1.4.0.tar.gz"
  sha256 "c5d7dbf7fae9aa3ed2c1184b49e82d8ac623ca786494ef6602cfe11735d28db0"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5fec58d7c3ab8a84979a637f41d0aba636a7a024dfd96582ab2e5ac9374c15e9"
    sha256 cellar: :any_skip_relocation, big_sur:       "5e3427fde42364771cbfab41b4eeb71889ac3a41737b6f54764fee1ec64c3e60"
    sha256 cellar: :any_skip_relocation, catalina:      "ba30e3d1544596f125755302d973c5c38975253da11018ad22e51722f32b3316"
    sha256 cellar: :any_skip_relocation, mojave:        "1eb7824102bc6234c8faf8523e50955f819403f3baf01837c72f79d4393536f1"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]

  if Hardware::CPU.intel?
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
