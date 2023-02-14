class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/1.9.1.0.tar.gz"
  sha256 "d8426defbbcf910fb706f7d4e8d03a6721e262148ecf25811bfce9ba80c76aed"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e62c4afc09a212f3c27ef3f2a0706ed213e723247bf7e1eaec06ae6916d9f057"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d51924d042a9068e184917ece822e3d90091e8ec07451685b6e9215040a47d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4dfcdac3f3cb16d6e548d081f88f8b1e716b11d62e969e25b1697758bbdcdfbd"
    sha256 cellar: :any_skip_relocation, ventura:        "60e943412424085eca64787d039cf7f61f774a2f7cb690a50d4742c2e3db5644"
    sha256 cellar: :any_skip_relocation, monterey:       "2a912cdbdfe61c6c1f9cec91525a2c655011a75d36c37791b7bbfcb7c16a03ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ecfa8ee93ba6110cf46a40b0c0d4269b474bff3241938c62e68c3fe28454fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b823e5acbb1f08d04d42b97c1bf600b93f6c140efc20d75e84e6fa40601b173"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]
  depends_on "ghc@8.10" => [:build, :test]
  depends_on "ghc@9.2" => [:build, :test]

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
      (bin/"#{hls}-wrapper").unlink unless ghc == ghcs.last
    end
  end

  def caveats
    ghc_versions = ghcs.map(&:version).map(&:to_s).join(", ")

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
