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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c85ed4d5cfafa11c3d5e9324ed9218b5c035706f7f1e4fb2ad0f8f4779033f98"
    sha256 cellar: :any_skip_relocation, big_sur:       "5f10f8aa957702ffaf808765ba51882e6722a2bc5ead7df1049b505c367fdecb"
    sha256 cellar: :any_skip_relocation, catalina:      "09dbe50487b7a7f838f7a58be237380ee312596fbe8774242d400b0046d0faa9"
    sha256 cellar: :any_skip_relocation, mojave:        "d0b9bd38d15545524db3acdeaf2037af7cbe81ab76aba556043f80373c48f263"
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
