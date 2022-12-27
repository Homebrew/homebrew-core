class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/1.9.0.0.tar.gz"
  sha256 "f62114928956090ea84c7e6b2fd16ca0d598c6d877e84dd87aebe81a9dabdd9c"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40af22428f511e5369d5c8acbdc4fc5031b090c032cf57c43ca59f7c8ee52ece"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f3aa7aa60da44f6881c60aab247a2e487c1676cb805b5d7a6ac480d518a5ef4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0836f3d83e63d0da82e9f198c81ab787e81d36dc4a5cd2c70f770d162e6f3388"
    sha256 cellar: :any_skip_relocation, ventura:        "02561ba835952cc58397acfbda8fedaeabcf21e29d2b10abb93e550a84b7856b"
    sha256 cellar: :any_skip_relocation, monterey:       "db38aeef73fd9a9cea8e8a5b78fc3b4d2b0c9f30376fd627bf42b23d6b14c816"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4620cedbd3de4349f66f9aa5e566b01d1d19e6f72c0102f33e37b6eb5bc863e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69ec5d6ecab4566c7d86637d13022da13c05f95aa3c48bf167aec0a4e7ed4290"
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
