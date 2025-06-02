class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/releases/download/2.11.0.0/haskell-language-server-2.11.0.0-src.tar.gz"
  sha256 "d6c7ce94786346ee9acb1ef9fff0780b8035c4392523f27d328ad018257d7f5f"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "24aa62e90da83646a9612ac91ae5cbda9e07483a92b32c1ba149099a1cf58c5d"
    sha256 cellar: :any,                 arm64_sonoma:  "b650a9c4d15038b8684d3b26915a6455468a2ed616a6bdf94caab869a67e19c3"
    sha256 cellar: :any,                 arm64_ventura: "a666556a48a11502cbfc4328d84ecfe637401e7734dc4bf32b119dff6fb3136b"
    sha256 cellar: :any,                 sonoma:        "49258ec924ca410511930293a6fb6ffbbbfd025fde2693c32a96a2760e323829"
    sha256 cellar: :any,                 ventura:       "d869bdcd6429246fc8e0d40a9c9fcfc470665b99cf9bb67cf54fb3efefd85a95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15dd391736a772ddc9cb298a26532f1c8cf08fd4f6ff6a967f4d54761057cec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20c2848958581b3fa31f2dff0659b411a344a8d1baa2d143ccf33239b0db3659"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]
  depends_on "ghc@9.10" => [:build, :test]
  depends_on "ghc@9.8" => [:build, :test]
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
