class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/1.6.0.0.tar.gz"
  sha256 "08703a234327b977cf6cff32d20fa3a4e3a2f8ea15d11c10fa51e69bb82bae41"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a26d77567fa8fc4c67c991b1faa82dc37c39f3a0db1b6870c0e01b81db4cb0fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33578298ae6b72c32495694103b0ffbaaab4cc682e0caaecb3d1deb055c2b341"
    sha256 cellar: :any_skip_relocation, monterey:       "f71a41af48ba7329d2f74e286c0d3e4a1bde06d695fffc2f738a1cf340966819"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ecf558e3c8bb158360117c84d7dee13b4c93ab3d399c0cfe47f40a43c39f815"
    sha256 cellar: :any_skip_relocation, catalina:       "28b669b2e8b50d94e8619eaee00707336160b98f7c6ba15a0c30dbabd84a6148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42f93080567942fe97558d0356674ca5308bddeef806fe10ac5814ab092c1c9f"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]

  if Hardware::CPU.intel?
    depends_on "ghc@8.6" => [:build, :test]
    depends_on "ghc@8.8" => [:build, :test]
  end

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def ghcs
    deps.map(&:to_formula)
        .select { |f| f.name.match? "ghc" }
        .sort_by(&:version)
  end

  def install
    system "cabal", "v2-update"
    newest_ghc = ghcs.max_by(&:version)

    ghcs.each do |ghc|
      # for --enable-executable-dynamic flag, explained in
      # https://haskell-language-server.readthedocs.io/en/latest/troubleshooting.html#support-for-template-haskell
      args = ["-w", ghc.bin/"ghc", "--enable-executable-dynamic"]
      system "cabal", "v2-install", *args, *std_cabal_v2_args

      hls = "haskell-language-server"
      bin.install bin/hls => "#{hls}-#{ghc.version}"
      bin.install_symlink "#{hls}-#{ghc.version}" => "#{hls}-#{ghc.version.major_minor}"
      rm bin/"#{hls}-wrapper" unless ghc == newest_ghc
    end
  end

  def caveats
    ghc_versions = ghcs.map(&:version).map(&:to_s).join(", ")

    <<~EOS
      #{name} is built for GHC versions #{ghc_versions}.
      You need to provide your own GHC or install one with
        brew install ghc
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
