class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/2.0.0.1.tar.gz"
  sha256 "58825b40fdbcffb8ad8690ec95c3ec82dfc5ba63cd19f2e50f1ea4dca10b2ea9"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf2cd5e4e2e230a72f1ed4726f809837c6ab89ce8dff72608f63c6acf368c43d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0b22b6c1fe428f9f541255dbb5bbb23514fb7624ca8ed89c98ea6357256c3fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe7f813e4b659decf7f3769ecc59e9f0c35fed5a01277b1c37be81dbfc96e255"
    sha256 cellar: :any_skip_relocation, ventura:        "5585a7dfb743475288c61625a584eed80ab8599975e493f5586837ea32c1661f"
    sha256 cellar: :any_skip_relocation, monterey:       "4489ae877767347e0890bb83719b2f8f4806e5515b85fe156d30df369c5a7eda"
    sha256 cellar: :any_skip_relocation, big_sur:        "9489fc8325a325141a4573d512183014371f4f2aff24642824489222999a3450"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87668b646813ed9ddfa55b16f617499dffafc86f5387f89b7e5bc43ac79ea1fd"
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
