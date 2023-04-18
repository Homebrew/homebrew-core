class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/1.10.0.0.tar.gz"
  sha256 "8b9bca5583243b647e230eb5b1e50980145a496a1927b4c3fbceb52590ff1d4b"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "567b2e0ad359d8c893ac32b9fb7679a0121f6dac055ee21d4e8b4b8bbf6f3c4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6840c8c478839081f72675751b2acaaf522701af337a74cacc36f074b1178e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73b5efcc583708eec704f0ef3226a9ed83676907a053cb0d85a2a981cdb7744f"
    sha256 cellar: :any_skip_relocation, ventura:        "675652b6532f3fb9599fe6662d64b768e7c5ff1c90a8584e11ea590b910e4f83"
    sha256 cellar: :any_skip_relocation, monterey:       "5e04fa42fb324f4aa4de2184144bf874ef9055e6119af04ece009e15b50ad2ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7b97e59f95159ec18f24c151eb6f0a3fa66712c7125c28345cb6d8902ff3e10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d259caefe5f37ab7106714f46d649f653a9b5d0d4cf82dd1069402b78888aa56"
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
