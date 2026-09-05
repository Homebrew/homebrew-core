class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/releases/download/2.15.0.0/haskell-language-server-2.15.0.0-src.tar.gz"
  sha256 "a6ecf9eeac802dfa358f151d4309803ca082671ed18195d1db0d60771a2159e2"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4f850e4cce2515edb1efaa7af4f0d9bbbfa40ba1baee33dfcdf77d318a1d6dea"
    sha256 cellar: :any, arm64_sequoia: "812c706399dfe479985d83d0d76f0b70508325a68c7a0d62b4c736e807121241"
    sha256 cellar: :any, arm64_sonoma:  "80b4f4068eb9b8c7e449b24f463b95f3ea3d8a1f249367a105ff46aab735fe85"
    sha256 cellar: :any, arm64_linux:   "483c934e6136e6de6ed62e5f4a233276523a6c6b38f86c83590f824871f2a97d"
    sha256 cellar: :any, x86_64_linux:  "d1e8069630b25eb9a25d2f03e1a1f9c349c038f7b5c85234062675783770a94d"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]
  depends_on "ghc@9.12" => [:build, :test]
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def ghcs
    deps.filter_map { |dep| dep.to_formula if dep.name.match? "ghc" }
        .sort_by(&:version)
  end

  def install
    # Cannot dynamically link when supporting multiple versions of GHC in single formula
    args = ["--disable-executable-dynamic", "--flags=-dynamic -test-exe"]
    # Work around failure: ld: B/BL out of range 204883708 (max +/-128MB)
    args << "--ghc-option=-optl-ld_classic" if DevelopmentTools.clang_build_version == 1500 && Hardware::CPU.arm?

    system "cabal", "v2-update"

    ghcs.each do |ghc|
      system "cabal", "v2-install", "--with-compiler=#{ghc.bin}/ghc", *args, *std_cabal_v2_args

      cmds = ["haskell-language-server", "ghcide-bench"]
      cmds.each do |cmd|
        bin.install bin/cmd => "#{cmd}-#{ghc.version}"
        bin.install_symlink "#{cmd}-#{ghc.version}" => "#{cmd}-#{ghc.version.major_minor}"
      end
      (bin/"haskell-language-server-wrapper").unlink if ghc != ghcs.last
    end
  end

  def caveats
    ghc_versions = ghcs.map { |ghc| ghc.version.to_s }.join(", ")

    <<~EOS
      #{name} is built for GHC versions #{ghc_versions}.
      You need to provide your own GHC or install one with
        brew install #{ghcs.last}
    EOS
  end

  test do
    (testpath/"valid.hs").write <<~HASKELL
      f :: Int -> Int
      f x = x + 1
    HASKELL

    (testpath/"invalid.hs").write <<~HASKELL
      f :: Int -> Int
    HASKELL

    ghcs.each do |ghc|
      with_env(PATH: "#{ghc.bin}:#{ENV["PATH"]}") do
        hls = bin/"haskell-language-server-#{ghc.version.major_minor}"
        assert_match "Completed (1 file worked, 1 file failed)", shell_output("#{hls} #{testpath}/*.hs 2>&1", 1)
      end
    end
  end
end
