class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/1.8.0.0.tar.gz"
  sha256 "e1081ac581d21547d835beb8561e815573944aa0babe752a971479da3a207235"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c55a376af53a07fe4c6b82a02df393f2b7fa3893b511e5a279d315cfb30aece5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0808834e5d3bf24dbd5492fd309b631f5eaf0e9a98312795f61573da3b53927c"
    sha256 cellar: :any_skip_relocation, monterey:       "bfc75df18a32b5d2992cd7940e896d6bba8e0426c8ed8a07a5437f428418f52d"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd0dbb35a976afc9601675267e468f52a6c98d7e40d2fa6d8a79be5f783372ab"
    sha256 cellar: :any_skip_relocation, catalina:       "745ae83e3aefeea846add644123e02c61e64c63b4db5ebae562ff8ac5855f920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3970275f9da78167e853dd9803ba2f85f8309b987c00012e2d7cd8642265e541"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]
  depends_on "ghc@8.10" => [:build, :test]

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_intel do
    depends_on "ghc@8.6" => [:build, :test]
    depends_on "ghc@8.8" => [:build, :test]
  end

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
