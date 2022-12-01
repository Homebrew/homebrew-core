class CabalCache < Formula
  desc "Haskell cabal store caching tool"
  homepage "https://github.com/haskell-works/cabal-cache"
  url "https://hackage.haskell.org/package/cabal-cache-1.0.5.1/cabal-cache-1.0.5.1.tar.gz"
  sha256 "4f464688f2d327d4f71c09697a95b3cb335dd29d0e173bb27675656906b1510a"
  license "BSD-3-Clause"
  head "git@github.com:haskell-works/cabal-cache.git", branch: "main"

  depends_on "cabal-install" => :build
  depends_on "ghc@8.10" => :build
  depends_on "gnu-tar"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    assert_match(/^cabal-cache .*$/, shell_output("#{bin}/cabal-cache version"))
    assert_match("", shell_output("cabal init --lib --overwrite --cabal-version=3.0 --package-name=foo -n"))
    File.open("foo.cabal", "a") do |f|
      f.puts "    build-depends:    random"
    end
    assert_match(/^Downloading .*/, shell_output("cabal update"))
    assert_match("", shell_output("cabal configure --write-ghc-environment-files=ghc8.4.4+"))
    assert_match(/^.*$/, shell_output("cabal build all --dry-run"))
    assert_match(/^.*$/, shell_output("cabal-cache sync-from-archive --archive-uri archive"))
    assert_match(/^.*$/, shell_output("cabal build all"))
    assert_match(/^.*$/, shell_output("cabal-cache sync-to-archive --archive-uri archive"))
    assert Dir.glob("archive/**/*.tar.gz").any?
  end
end
