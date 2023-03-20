class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/1.9.1.0.tar.gz"
  sha256 "d8426defbbcf910fb706f7d4e8d03a6721e262148ecf25811bfce9ba80c76aed"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74e193c8a97cce17043c3446ad3161dd8ea3bf1f89978b422a460e5f3ad94008"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6c82e0ccbee0a428ddadf6069d7883876379cf04b996fb9bb8538cc6f3bb0a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "586ed47ef238ced2c6dcce32e261b58645f366dcccd2a9dbf97ca4d63dc2bf78"
    sha256 cellar: :any_skip_relocation, ventura:        "113fb5844ab6d62e57b09ad77dbb038add2cb03c56408a0af92484ca2dc7fc41"
    sha256 cellar: :any_skip_relocation, monterey:       "b4512b54b70b7d61be72e50efd5643b48e6825c11db3891ece12a9d3f5f3f50f"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ad009e8b9964bdfb050bbaff456318d835fc35276fcfd9aae025562cb815f8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea900ac2606a3fc30534c63f2820399b3e5aae6d057d208b6d5ea3fb0bf3dbc0"
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
