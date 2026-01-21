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
    sha256 cellar: :any,                 arm64_tahoe:   "31d7cacc644a5768ae6a79a22579cd91a82255382084aa70e02f3d3d740912b0"
    sha256 cellar: :any,                 arm64_sequoia: "2748e751c5205e2cce267c851c1acd995b2f15e063e30b9abd7d787ac0161565"
    sha256 cellar: :any,                 arm64_sonoma:  "84952f21eb2873d0ec9ddf94b609f285df3f2ec59e9261d4854d8d715bee8784"
    sha256 cellar: :any,                 sonoma:        "393a6adff3f052d054a7245ed419f991babdcac79a53e22ccb7e3361b8e7a687"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ee4031901feafa852742643c5cd6e558f9f8b7c83aaaf5f7e139435acdab26b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f8ccd5ae69eaca97a90bb059e0a586c572e1258c91f3210ff7668c9f88acf4f"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]
  depends_on "ghc@9.12" => [:build, :test]
  depends_on "gmp"

  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
