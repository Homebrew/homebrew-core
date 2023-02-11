class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/1.9.0.0.tar.gz"
  sha256 "f62114928956090ea84c7e6b2fd16ca0d598c6d877e84dd87aebe81a9dabdd9c"
  license "Apache-2.0"
  revision 3
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21b04bcc5ecf3a1350605cbb48094359d5435ca1ee0ff2a0aff065c3552413b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b2f375b12b54338b17782202c7b81d4f5c7e754d14a7d79b6773e685bf59f6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e181bb3f6d163f120532efef9523a7db7661e88e421665d7cf09fc1a1e6fb2f"
    sha256 cellar: :any_skip_relocation, ventura:        "78e4211c42ea0a6e3f25e8218d662f9899af5d783a21923fed0da7469436f9ab"
    sha256 cellar: :any_skip_relocation, monterey:       "524d8ac705fbb381a389bead45770afeadd80758ef7473dd2d2b6d6c8873ba47"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccd0655f3475d1e738ebadcfc90a1b4a1c44f346ec48403cfc70a24da147ea13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b066beb744863f22a7b9d57f9676f8038e866410f78188589e698d41c693be4"
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
