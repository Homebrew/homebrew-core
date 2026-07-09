class Ghcid < Formula
  desc "Very low feature GHCi based IDE"
  homepage "https://github.com/ndmitchell/ghcid"
  url "https://github.com/ndmitchell/ghcid/archive/refs/tags/v0.8.9.tar.gz"
  sha256 "8e6ba85ef6184020a6e11fac5226c6a13e905c44b2e56d288f1fd0b3f0b34038"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/ghcid.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e3a2377db77d7a3b2c0a6d29395e0098610cac7775923e0492ef97da8f9db540"
    sha256 cellar: :any, arm64_sequoia: "4375fa572a0578598a1042dcbad666e276fd977c9d62bddd2bfb341d07e7d05f"
    sha256 cellar: :any, arm64_sonoma:  "7f26067c76ba687f968a0a6e490a92297233617d35fdccd618dcecc4960e6ef2"
    sha256 cellar: :any, sonoma:        "2fcc824964d3eb194c18f54e2bace7c2014775f5a052e9bf87261b8269e2ebdc"
    sha256 cellar: :any, arm64_linux:   "3453316aa7aa20b0a322463f195bc26a8cfede1f2d54080b59ecce962b1dc855"
    sha256 cellar: :any, x86_64_linux:  "5a2009be9b09580db4d803195805136fc30aac1615fec93e778e1d4a387f7c49"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => [:build, :test]
  depends_on "gmp"

  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"Main.hs").write <<~HASKELL
      main :: IO ()
      main = putStrLn "Hello, World!"
    HASKELL

    PTY.spawn(bin/"ghcid", "--command=ghci Main.hs", "--clear") do |r, _w, pid|
      output = r.gets
      assert_match "Loading ghci Main.hs", output
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
