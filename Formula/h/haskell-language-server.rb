class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/refs/tags/2.7.0.0.tar.gz"
  sha256 "f84394954ed29ff5f99a3710e4581809d0a0641ba726a41bf031e7bc7e9d3455"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71be80dde9873b435968527063c8b26d836bf9e25b8c00cb9217328803b5bd1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62c8fc0ebe628433433e64176be242cd8453c898ef359480a4cc8e62a45f26c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f80249dc475059ba769c6b731af820849d924a3a463debeb1effc0af128b840d"
    sha256 cellar: :any_skip_relocation, sonoma:         "204d45443fb901de7904647e46a4d35cb92220b149fddf48cf618842a1e535e7"
    sha256 cellar: :any_skip_relocation, ventura:        "bd056dc1ec1567ffb371bac41c06e2edbaf6395d576e12965fe8a9eefc147e0b"
    sha256 cellar: :any_skip_relocation, monterey:       "7e400696ce651ec615a56f547db8014110aa3989b8b1927df4ed0c1d54be3b62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d93d0c6b2540feeb68a2143a660d2b2d1b3ead71e16e6015ed247c02e447f885"
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
