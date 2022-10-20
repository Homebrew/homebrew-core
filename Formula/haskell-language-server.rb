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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf00ea6424aeca6c4159348fb18e098edba657166616bccda8e32fe457382589"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ad7dfeb2638c5a9938dc6f3b7724f7ef0dfd748f58024172bda77567ef54f55"
    sha256 cellar: :any_skip_relocation, monterey:       "b5ee85bbf76737036206843fb9d3381e712495c5ecf19d30500fa0738d6dc3f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "b916bba19076554209aea3fb359b323762044ca8a74bfb9ff67662b15cd335c8"
    sha256 cellar: :any_skip_relocation, catalina:       "eaabfb9b4f28088843f180577afbf811b5273fc091261fbb2ab637d373bea85a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "068dde2e6fec89fdc79e710befe909b86570024da48f4daf9be135df6d4c04d6"
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
