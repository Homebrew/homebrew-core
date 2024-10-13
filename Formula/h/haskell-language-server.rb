class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/releases/download/2.9.0.1/haskell-language-server-2.9.0.1-src.tar.gz"
  sha256 "bdcdca4d4ec2a6208e3a32309ad88f6ebc51bdaef44cc59b3c7c004699d1f7bd"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e50ed5add3e104d152871aa41670d5793907cd835986735dc3cc0c7e139b90b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46b1067ee77c8d2741f9e26744786cabc80e62a6b29befcaaf38058067953102"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56df7ae9fc11ea8d19ccc3adff4a9fd7844f8e15200e5469fa90815b8c8a89b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a11af473d8a8eaea5159c5fa4827b59551ff705bca1d057d75aa6ae8f40d2a3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1e671aa10750b612d12a45f815a35416998662188e954d80a16a55377d9f50e"
    sha256 cellar: :any_skip_relocation, ventura:        "739cbff9e9abd601ffe31628417f6a0cea26a7c05e70b384bf40b2765f40d9a9"
    sha256 cellar: :any_skip_relocation, monterey:       "ecfbbe1f719963f7e3f45fe27e14ca98b07218525f8c23af886e67450a9a6242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afbb8f67dc62f0f72ebbbc7ce88e10c3e5a65abac2df6d2f86132676f15041d6"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]
  depends_on "ghc@9.6" => [:build, :test]
  depends_on "ghc@9.8" => [:build, :test]

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def ghcs
    deps.map(&:to_formula)
        .select { |f| f.name.match? "ghc" }
        .sort_by(&:version)
  end

  def install
    # Backport newer index-state to get `hashable` fix needed to build on ARM Monterey
    # Ref: https://github.com/haskell/haskell-language-server/commit/376f7f1802298d23aff6aa94592cd46c4d68e61b
    # TODO: Remove on the next release
    inreplace "cabal.project", ": 2024-06-13T17:12:34Z", ": 2024-06-29T00:00:00Z" if build.stable?

    system "cabal", "v2-update"

    ghcs.each do |ghc|
      system "cabal", "v2-install", "--with-compiler=#{ghc.bin}/ghc", "--flags=-dynamic", *std_cabal_v2_args

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
