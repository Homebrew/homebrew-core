class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/releases/download/2.11.0.0/haskell-language-server-2.11.0.0-src.tar.gz"
  sha256 "d6c7ce94786346ee9acb1ef9fff0780b8035c4392523f27d328ad018257d7f5f"
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
    sha256 cellar: :any,                 arm64_sequoia: "7be400445f57f8ee34805bb545c823c9931bda77403edef1fe3405ca08c92f9b"
    sha256 cellar: :any,                 arm64_sonoma:  "9fa7706a776f4dfcf82fcbcf383eb0c5c824a6acc06e81f616074353bc7ec6eb"
    sha256 cellar: :any,                 arm64_ventura: "41e8c785115b01629f316c27fb74cc832d842c1539dc4764d892019c09c621be"
    sha256 cellar: :any,                 sonoma:        "2caa0b5cac34bfbe307395de3d663718f3114021bbef8787d2d3766846a6cf36"
    sha256 cellar: :any,                 ventura:       "9d12d6dd4f5724f7d2bd11abdc1b5f8da4188f6487fadc1ab4ee566f9e7dea49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de58cd51f2fb307f4fab971c18a75893414ba74df714c9cbc8d1da230441e740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4b2199524258a615108132c1bb926f3d15016ad4841a9b7d27382241e226573"
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
