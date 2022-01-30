class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/1.6.1.0.tar.gz"
  sha256 "e5c336ad2de8d021c882cdac5bbc26bf6427df8d2a5bd244c05cf18296a9bfdc"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "363016754f7ebcf1013051870a6ee33818b0e9cfa4a7bded7d0c41c7c129ef4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "752f2a789710765cf175f3116763c66ab99ae6b93065fae76888c8c1612df227"
    sha256 cellar: :any_skip_relocation, monterey:       "7d06aad086305413b36d1b814bcece11637d23c5fa72e70e626f8dc04ea519b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbe05230f838ff57510558b15217063f02012aef2f5d68ef9af2ac71c55f8266"
    sha256 cellar: :any_skip_relocation, catalina:       "0ecec6cfdad9567719385667edbf1bd38a773f9ce8bc293b1eb440dea60c2e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b47c0d0083a8251b48007e94055cac6ac198212f2c38286d11f3f57fa12ae6bb"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]

  if Hardware::CPU.intel?
    depends_on "ghc@8.6" => [:build, :test]
    depends_on "ghc@8.8" => [:build, :test]
  end

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def ghcs
    deps.map(&:to_formula)
        .select { |f| f.name.match? "ghc" }
        .sort_by(&:version)
  end

  def install
    system "cabal", "v2-update"
    newest_ghc = ghcs.max_by(&:version)

    ghcs.each do |ghc|
      # for --enable-executable-dynamic flag, explained in
      # https://haskell-language-server.readthedocs.io/en/latest/troubleshooting.html#support-for-template-haskell
      args = ["-w", ghc.bin/"ghc", "--enable-executable-dynamic"]
      system "cabal", "v2-install", *args, *std_cabal_v2_args

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
