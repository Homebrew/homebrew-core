class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/1.9.0.0.tar.gz"
  sha256 "f62114928956090ea84c7e6b2fd16ca0d598c6d877e84dd87aebe81a9dabdd9c"
  license "Apache-2.0"
  revision 2
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3b5f022440aad940360e73b63c547fae217faf51d99a9a371bf74dfcc8de21e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36c2b132a78ec63ff3c378a128f10ebe522aceb48ba1ede8e5e66fda55ecf17f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "205bdd8cf7190040165fa9bbc3d380762615229de344513c6c63bfbbb135cf9c"
    sha256 cellar: :any_skip_relocation, ventura:        "ef13ac73a96cd9458c9cf752475c1a536023f6132b6a860747939a663fc14202"
    sha256 cellar: :any_skip_relocation, monterey:       "ffff4e151523bc9417fb4a1bf83250b4d0c31330c9d0bd80e3f6d74404a6006e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7c636a2484695f93afddc59f3cd78c2785464eaddfc7d37685990845b11b807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e3bde86467858e6619fed11e2588b54728de87c004c774415a72bf4febfdbfd"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]
  depends_on "ghc@8.10" => [:build, :test]
  depends_on "ghc@9.2" => [:build, :test]

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def ghcs
    deps.map(&:to_formula)
        .select { |f| f.name.match? "ghc" }
        .sort_by(&:version)
  end

  def install
    system "cabal", "v2-update"

    ghcs.each do |ghc|
      system "cabal", "v2-install", "--with-compiler=#{ghc.bin}/ghc", "--flags=-dynamic", *std_cabal_v2_args

      hls = "haskell-language-server"
      bin.install bin/hls => "#{hls}-#{ghc.version}"
      bin.install_symlink "#{hls}-#{ghc.version}" => "#{hls}-#{ghc.version.major_minor}"
      (bin/"#{hls}-wrapper").unlink unless ghc == ghcs.last
    end
  end

  def caveats
    ghc_versions = ghcs.map(&:version).map(&:to_s).join(", ")

    <<~EOS
      #{name} is built for GHC versions #{ghc_versions}.
      You need to provide your own GHC or install one with
        brew install #{ghcs.last}
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
