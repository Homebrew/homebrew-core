class HaskellLanguageServer < Formula
  desc "Integration point for ghcide and haskell-ide-engine. One IDE to rule them all"
  homepage "https://github.com/haskell/haskell-language-server"
  license "Apache-2.0"
  revision 1
  head "https://github.com/haskell/haskell-language-server.git", branch: "master"

  stable do
    url "https://github.com/haskell/haskell-language-server/releases/download/2.9.0.1/haskell-language-server-2.9.0.1-src.tar.gz"
    sha256 "bdcdca4d4ec2a6208e3a32309ad88f6ebc51bdaef44cc59b3c7c004699d1f7bd"

    # Backport support for newer GHC 9.8
    # Ref: https://github.com/haskell/haskell-language-server/commit/6d0a6f220226fe6c1cb5b6533177deb55e755b0b
    patch :DATA
  end

  # we need :github_latest here because otherwise
  # livecheck picks up spurious non-release tags
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ca04aceddff878e084ee95e1b350679f6496ef59f3fa8f888022530241e1a8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e465529fa959635d64b58f489e565b316530246cdb17fe77caaf9a047958b23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4b7056eb268074e77b59c6cd162a4d56b30a711d7504d9b7fad0068df528e21"
    sha256 cellar: :any_skip_relocation, sonoma:        "feb62de0788a945aa9effc9cf8309a3af9781c2960311c0d09dc403435611e21"
    sha256 cellar: :any_skip_relocation, ventura:       "5bd0b38d098fff1453dd0fafb897b23ea908872b90df89ff69594c52b7655ba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37b70a3d3a35c2e55e5227d37f13a136cfa2b191e32917b7feaeeeffa999553a"
  end

  depends_on "cabal-install" => [:build, :test]
  depends_on "ghc@9.10" => [:build, :test]
  depends_on "ghc@9.6" => [:build, :test]
  depends_on "ghc@9.8" => [:build, :test]

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def ghcs
    deps.filter_map { |dep| dep.to_formula if dep.name.match? "ghc" }
        .sort_by(&:version)
  end

  def install
    # Backport newer index-state for GHC 9.8.4 support in ghc-lib-parser.
    # We use the timestamp of r1 revision to avoid latter part of commit
    # Ref: https://github.com/haskell/haskell-language-server/commit/25c5d82ce09431a1b53dfa1784a276a709f5e479
    # Ref: https://hackage.haskell.org/package/ghc-lib-parser-9.8.4.20241130/revisions/
    # TODO: Remove on the next release
    inreplace "cabal.project", ": 2024-06-13T17:12:34Z", ": 2024-12-04T16:29:32Z" if build.stable?

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

__END__
--- a/ghcide/src/Development/IDE/GHC/Compat/Core.hs
+++ b/ghcide/src/Development/IDE/GHC/Compat/Core.hs
@@ -674,7 +674,7 @@ initObjLinker env =
 loadDLL :: HscEnv -> String -> IO (Maybe String)
 loadDLL env str = do
     res <- GHCi.loadDLL (GHCi.hscInterp env) str
-#if MIN_VERSION_ghc(9,11,0)
+#if MIN_VERSION_ghc(9,11,0) || (MIN_VERSION_ghc(9, 8, 3) && !MIN_VERSION_ghc(9, 9, 0))
     pure $
       case res of
         Left err_msg -> Just err_msg
