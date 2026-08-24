class Ghcid < Formula
  desc "Very low feature GHCi based IDE"
  homepage "https://github.com/ndmitchell/ghcid"
  url "https://github.com/ndmitchell/ghcid/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "6317ed3a0c83c1d1d5b03ca40d7b6906d208850b46dd6a372ea90345946f3b4f"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/ghcid.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "310f31bcaae877f6c38661e74398f90dbe1da2df04fe518cef0a62f594cf8533"
    sha256 cellar: :any, arm64_sequoia: "ccb28c12d791eaf4860378a29b2cb9d33e31a7ffcf70b324180794afc91fdcac"
    sha256 cellar: :any, arm64_sonoma:  "16d72791440fc4fc99bb7d089478820b24ac41be4aeaa98dc258cf9f5103a847"
    sha256 cellar: :any, sonoma:        "705a1e0f488714956665e7f3b3b09222261cdc2e0cc3d4b555901acccfceb733"
    sha256 cellar: :any, arm64_linux:   "0353b2413757ae36ddfb6006717e4988787bad0aa5c62299668e63af41f76ac4"
    sha256 cellar: :any, x86_64_linux:  "363d56b747f64ef8d3981f9598f2e12065471748b1368107a82ab15f13dc0884"
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
      assert_match "Starting ghci command: ghci Main.hs", output
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
