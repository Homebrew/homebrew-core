class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/2.0.0.0.tar.gz"
  sha256 "89546fc095aae0705420b9e035cf3c1d475c094729f6b2bf493b7cb673c9b230"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68fc935796a4f1b1ee8dea0912e6a3244d72c4c8972e83c34706ae9da979fdcf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f0bd0c1c925f2bf768834d47bb4cf135a27454086ef45b73a38a27ed6a1c3b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8c415f620fba36e4651edd1c4165fdc24baf767d4b9e46aa7f3c2b91547708b"
    sha256 cellar: :any_skip_relocation, ventura:        "e52d0e827493bef90864227f3f751a786e093ce3063861ee79104f6b1db196cf"
    sha256 cellar: :any_skip_relocation, monterey:       "406fc5cec4ea27a21d1fb38c9956fc4cb18a34b0e41585ec8989f2b7a5e15e4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c8a935597c5239e9aa67a356e4a58939a634cb916fbe003f49be0113d72c03d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8eebeb93cd5aeeafb7bb5ad89ffe7f95842de988b3eabbcfff2180c39097554"
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
