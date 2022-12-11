class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/1.9.0.0.tar.gz"
  sha256 "f62114928956090ea84c7e6b2fd16ca0d598c6d877e84dd87aebe81a9dabdd9c"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "659fdb573cffe5ebd26f0ea34d43df7987026cbaa05a51391edba48adc40c013"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "977174a0546191cb6e298b8ff1ed3db3b09bf00770fb0823e86905d7b4e79870"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4ba6f9cc4d91d4ea6a4fe27e00e3975831cab93b6cfad91e7e9a50c4006160e"
    sha256 cellar: :any_skip_relocation, ventura:        "ce9e5649a934a3f5a2184c1c8e14739e232881fb397ee3c3d0355a2c2de8f086"
    sha256 cellar: :any_skip_relocation, monterey:       "c7161b93a50d0b1da7a9e3c7edcf39869560d0984d21b229f3b2bc784890dcc1"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ddbd010bf69bacef286bfb00c7332f8891a012ee9076bb23c10219aaa20c8fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b7eaee5459e15dba442c94ceec42a32ba7784a6576835035dfdca9bf6c6ef34"
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
