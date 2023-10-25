class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/refs/tags/2.4.0.0.tar.gz"
  sha256 "67bbfae1275aabbfdb26869bc6df91feb58e03427cb76df89f74b864dbb5d57b"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b0c4afe14bc78ccee8865ab32baec658d786080ea3fbaabdb82b78ea6c95dda4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d428be5d261a58d0c50017290478a150ea4508412dd31f35da4ca81bbe6e8581"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db7b3d8c2f0b5f5de1a7d7d43bf622afe6ac465de70bd42ed79022a4cdf42728"
    sha256 cellar: :any_skip_relocation, sonoma:         "38a68d6c518792d2ee6c1c40a837a931b9abda201cf2c8339377c693ec89efe2"
    sha256 cellar: :any_skip_relocation, ventura:        "c10b30a7a8a7d7524c31d2bd5e1fac56bfd06f3110ca73b95bbba990c4dc6e23"
    sha256 cellar: :any_skip_relocation, monterey:       "a618bfc394a815db8f881568fdfed20f568360fe9deb6366ca18ddfead10704e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0caecce009a1e206f68145f0598382a8b6878c7f0a2aa5eb91897161a27bc95"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]
  depends_on "ghc@9.2" => [:build, :test]
  depends_on "ghc@9.4" => [:build, :test]
  depends_on "ghc@9.6" => [:build, :test]

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
