class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/refs/tags/2.4.0.0.tar.gz"
  sha256 "67bbfae1275aabbfdb26869bc6df91feb58e03427cb76df89f74b864dbb5d57b"
  license "Apache-2.0"
  revision 2
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00af4c28bfe393958ee2483b8048083559fe7bc217801e437bf5eaec2e8a972f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ad465fb691d784834b903224e3e5d2c6a41d22e1e5c089373baddac953b9d18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e13e6161536dc4416267b6302947f4d0125ab0e270edb3b3f71fe0b10aa44fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "55cd7e7913f4988053eaedd9a195e8ca8ea0a2e7fc0d767c47a0b1befe498ca8"
    sha256 cellar: :any_skip_relocation, ventura:        "efb3454b042062bc29f9b74a53842214d04e7ebd218857831eac73d6ed39746d"
    sha256 cellar: :any_skip_relocation, monterey:       "c40e40a5603875f954db19ce343e818100114b0fbaf57b52a760c8a60ee8b3de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0893c88c89683de459bc0f2acb6e0110329281461afd92a146db1197d4ccab58"
  end

  depends_on "cabal-install" => [:build, :test]
  # ghc 9.8 support issue, https://github.com/haskell/haskell-language-server/issues/3861
  depends_on "ghc@9.2" => [:build, :test]
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
