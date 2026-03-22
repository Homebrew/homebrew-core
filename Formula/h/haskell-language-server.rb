class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/releases/download/2.13.0.0/haskell-language-server-2.13.0.0-src.tar.gz"
  sha256 "c53f0da9aa9d9924265487ba1e03aabc7dbd54075e2785f931c15b0090829a1e"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f6de8b8fa5d1f31b2ff6ef634396c9100cab345a8185824ad1c86b6787dda02c"
    sha256 cellar: :any,                 arm64_sequoia: "aced147259a317e32d3f16bfb61f0f82233bed806b4cec722c253f52496b764d"
    sha256 cellar: :any,                 arm64_sonoma:  "d4221d8508168e7387229d9c9d8882842f7f5e0fec4255a1472e9d9a38b2cb1f"
    sha256 cellar: :any,                 sonoma:        "72ea8a68e64d2c5884c5088fb41615c3a0099cbf9aa8e0588d8bffe4c31c3b8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e1bd524e3263e877838a83420c514c109c704a7a1ac13a8818aae2d7995579b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42f44eef799fd9a7ed15d33b531bcc8c0242fac8424d053d39bc776af3837b55"
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
