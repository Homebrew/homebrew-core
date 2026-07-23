class Ghcid < Formula
  desc "Very low feature GHCi based IDE"
  homepage "https://github.com/ndmitchell/ghcid"
  url "https://github.com/ndmitchell/ghcid/archive/refs/tags/v0.8.9.tar.gz"
  sha256 "8e6ba85ef6184020a6e11fac5226c6a13e905c44b2e56d288f1fd0b3f0b34038"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/ghcid.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "a4da8526d57f1d72b83b49023807d92eb4e8e69fe6273a50c61df3731bc5eb1c"
    sha256 cellar: :any, arm64_sequoia: "617e6358138be46ffa217159beb1ea303de2288619f7b1ae1465e6c8b5d0b8b3"
    sha256 cellar: :any, arm64_sonoma:  "f27b570f92c6ec4797605438a3f2932ab614c6a8f9c0e333fe6322a2ac366fce"
    sha256 cellar: :any, sonoma:        "e6438ef22dfb27ca1d10782f90da0f50652598a3efb04fb9091773e62e9be8be"
    sha256 cellar: :any, arm64_linux:   "16cec1e74b65ab7aefc266234a80cbf1dc1507ce3cd711c803f99018af69075b"
    sha256 cellar: :any, x86_64_linux:  "c34284605f6c77474156777f8bcd01190fcf34dfa32723f5b0e61096450f1cfd"
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
