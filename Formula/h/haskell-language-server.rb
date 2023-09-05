class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/2.0.0.1.tar.gz"
  sha256 "58825b40fdbcffb8ad8690ec95c3ec82dfc5ba63cd19f2e50f1ea4dca10b2ea9"
  license "Apache-2.0"
  revision 1
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24a2e2490403a4f6351fad0eac00aefef998a4692b19c029aecffe517aa6407a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd7aee7f31573e85620feda07acdd9ac004ad40374e1898798b4568587edeefb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32d99906c2867200a8f05383c86c43d8cf133d847be9addc4c7e3b3dea6b9c17"
    sha256 cellar: :any_skip_relocation, ventura:        "a169425b335de8cf348f9ac6ddffea852e0f01925646b8f4c17b1b0c86baab74"
    sha256 cellar: :any_skip_relocation, monterey:       "6f58b12988fc462f19745e2716a20833447ffff1f85c8abd265b0ce426e9be60"
    sha256 cellar: :any_skip_relocation, big_sur:        "c538ee5edb9af9c74b24edf577a05367d6c859a85b0ca2d63e25c0f3194378b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36876b721e850c1e78fafaf40eec8ef966e5616302260514e84259fd144925df"
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
      (bin/"#{hls}-wrapper").unlink if ghc != ghcs.last
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
