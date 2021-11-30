class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  url "https://github.com/haskell/haskell-language-server/archive/1.5.1.tar.gz"
  sha256 "fa2b1d39d413283202ee1f75e4ad9fc44544535741370d6f1e63afd5878d9e40"
  license "Apache-2.0"
  head "https://github.com/haskell/haskell-language-server.git"

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db6100ae789dd9c323c4226020a0b2c4ae976fe253643a39be557ab6e2f9c34a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1950e3eb9d77b9cb32abf313de8747481b6aa6ed8f949212d23513f8d1f8d92b"
    sha256 cellar: :any_skip_relocation, monterey:       "0e6306333ebd9de2f257d48a263775a1336789480b614922b517aee362c02a62"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb92175df8b9403eea3aea99be3dc77e9d9e53c051b9d614590843896f615b45"
    sha256 cellar: :any_skip_relocation, catalina:       "636874b4321f7aa0ae1f0a32b0bceaed96464006e3b4b3c3f04cfc390dcb2020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88d634406571ed86ec9fb4782fcd5386a8abe9248f0868324feeca4453ebe8f8"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc" => [:build, :test]

  if Hardware::CPU.intel?
    depends_on "ghc@8.6" => [:build, :test]
    depends_on "ghc@8.8" => [:build, :test]
  end

  def ghcs
    deps.map(&:to_formula)
        .select { |f| f.name.match? "ghc" }
        .sort_by(&:version)
  end

  def install
    system "cabal", "v2-update"
    newest_ghc = ghcs.max_by(&:version)

    ghcs.each do |ghc|
      system "cabal", "v2-install", "-w", ghc.bin/"ghc", *std_cabal_v2_args

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
