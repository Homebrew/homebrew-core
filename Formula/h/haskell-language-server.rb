class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/refs/tags/2.6.0.0.tar.gz"
  sha256 "b23a165121553b59dde8f7e8f9ce24b8eee39d6b6ed5fae20d0882ec16f9da44"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea27664baf76eb5e7250bcd44905117e8c4b9567f533d4f37b71c55da11d1de8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43fddca0b320eafa662f8d41b912f0a3c10bf8626a252db53dd53e9f2a4fd0d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cf6f01f0a21207b780f654ab02209050e9e2e44d253a8b56db8e229847aad6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "24e63d769dc44c93183d007b93fdcb2147f03ab3ff9accb562f5bc5a3e2471e8"
    sha256 cellar: :any_skip_relocation, ventura:        "9c2903045040556f2df2fb5948ee364d5afbdd0ac17761a4e31113eff8112509"
    sha256 cellar: :any_skip_relocation, monterey:       "d6a56784a7cf216ba30769634ad551e9c98156875dc688ed72108768014dcf63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46bc2e7ba3e90bd9024ee8aeda745d4f25040e954eab2118c3fd96599a5069e5"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]
  depends_on "ghc@9.4" => [:build, :test]
  depends_on "ghc@9.6" => [:build, :test]

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
      (bin/"#{hls}-wrapper").unlink if ghc != ghcs.last
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
