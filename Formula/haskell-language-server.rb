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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0ad6c8c40ff0df523896a1b309ad35959b6e4073ae3cf42f2d44778ce50ea0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68160af99a6fa13e8a1554739e9f658a76c80000503fa55932aff1b17b6c4e62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34e8d0c2582483db1fdebbf3eb04a2e366d37e71770a55a0991cd1d00c24467a"
    sha256 cellar: :any_skip_relocation, ventura:        "e5e2e3cf077f241582873ad75a6afed3bd0ab49aedb16614ca9ccf0fc65799fe"
    sha256 cellar: :any_skip_relocation, monterey:       "2c1cffc3eb8ddc8403c4f8b2b5a897185d722b508ad1746fe5a90f2c7b9fc3a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f80ff534c4a7ead96dbdce97aa732b687a27d7b6d7bff150b9a691cc5fa4eb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab91bffe88d1865117d158bca39b0de17af8d55ad3f7798d1125853f78783ba5"
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
