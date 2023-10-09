class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/2.3.0.0.tar.gz"
  sha256 "cb8248aacac0ad02cf3f9d9904c54cd5527c08e47b91cf032ace732d910198a4"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc04b56cba776c34ddc5c48cf236e6a7cc063f2f330aeb829e5092d4a8895406"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8af483f4392243161ac93aa6e504d39bf7ba483499cde44dec397a0ac9c43907"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "031856696444c232e96935594abc301fc461c4e9448283fca22f3ae035a04250"
    sha256 cellar: :any_skip_relocation, sonoma:         "60702c57f0f6f173e0276ea63c0d0718cf2a064c602ca2bd12b00b05c267de97"
    sha256 cellar: :any_skip_relocation, ventura:        "2268d111aa7564175e4a70fa31332e189a8c4949a947f59785b903d184a1118c"
    sha256 cellar: :any_skip_relocation, monterey:       "0580a430f6229674af31aa50ae000a7450e2e88366f6fa0c42adc7f9467fe28a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4205a8a08e6861126453ddcecc63527a4a7614767a953c69b68fc31d7cde2f1a"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]
  depends_on "ghc@9.2" => [:build, :test]
  depends_on "ghc@9.4" => [:build, :test]

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def ghcs
    deps.map(&:to_formula)
        .select { |f| f.name.match? "ghc" }
        .sort_by(&:version)
  end

  def install
    # Fixes https://github.com/Homebrew/homebrew-core/pull/141617#issuecomment-1748282534
    inreplace "cabal.project", "stm-hamt < 1.2.0.10,", ""
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
