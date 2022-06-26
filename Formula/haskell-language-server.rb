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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a775f8124deb496ccf4e54fd369675bf6dc591c37aeee2e182ac5be9fd60601"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6ceb7facfe09c3c0e86a343b846a8d08c3760a22b99ffcb16317e7b351ccdbc"
    sha256 cellar: :any_skip_relocation, monterey:       "f3facd6ba2cda0a0564fc3f77d50f3710078969ea07387de723b58c429a2ddd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "98fb38457acb2e9bb7939fcf3c6c082b47f5b35b6d845ecc1560483d8a611b80"
    sha256 cellar: :any_skip_relocation, catalina:       "1111441e2b71d71cdc3e61e16f4382d40459f667c970816e867a305d8a8cc063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16316d3c14e8f44d17ac79b95071bc129be26a33622af4221f7bad7d2071b3e4"
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
