class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/releases/download/2.10.0.0/haskell-language-server-2.10.0.0-src.tar.gz"
  sha256 "dd7ba032767e9a955f334617eef8f4b8b12b260191f97ad883545851f498dc0a"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a49980333b291f0817180be4b6d35818b0d6ab670943623dccb9c9820f8339c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d23f1a7a36b002d29587f5077262654b80100471200b870bb7987e5d8448cd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61bf5b68dc9cd636f5a2ef3792a8c955a33e461544ce2da87efcb1cb29975358"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2b798ae2b7c005c05170f7e92f653b939ed51e4f6e907e737ae9b3bf5645923"
    sha256 cellar: :any_skip_relocation, ventura:       "e04bb44cbacf239ec843f840bc6887a760c4a021abc6996465a5d8d85b88947b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7784b1f454b182e6227b1ead86db9e4a04d5b22cef627bb3743ec4d95645711d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bab5d18cee8d36906dc58806f1c42ef705ad217c2b2521648284ecf900f8d042"
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
