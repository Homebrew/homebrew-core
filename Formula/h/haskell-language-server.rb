class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/refs/tags/2.8.0.0.tar.gz"
  sha256 "af6c76d21d577c2712ed7106d8ba00ec734c9285de58293f78e1cc1cc203d154"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "505d7b4ee2b01efdc08f118d25e56571644a20b59307f85674aec94751e46eea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3919af365fad785cef7cbe4a7a4dae370ec2da8f1f67412e786dd3446e2eba9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06720b41aaad6db9d89b14eea83ad64e207d1aaab9d323074f8b883748526585"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7871a9fc22cb17b90e25dd6c2f7b73a24342219c1381d8512e08f3f46433f83"
    sha256 cellar: :any_skip_relocation, ventura:        "b3bc88498494cbc92b7d8557af3dc772e73803af673d6cdedaded329b557ad34"
    sha256 cellar: :any_skip_relocation, monterey:       "837179ca16259f27e96687f167beb869438188ab195ad33faa82eafce7a5b587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f424fc867d3199ff6aeec9d70a09e7080d001f54b4a9e7fd79ed82c94f85b00c"
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
