class Fourmolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/fourmolu/fourmolu"
  url "https://github.com/fourmolu/fourmolu/archive/refs/tags/v0.19.0.0.tar.gz"
  sha256 "0ca870594e87ffa19fd39e49a65c45d4171f31b06bf03b6fd62717d7da93f323"
  license "BSD-3-Clause"
  head "https://github.com/fourmolu/fourmolu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4d79b102fd0d4bff3b2b30e526153f0a5fe92f514ac7b28b89dc1f2d459fc643"
    sha256 cellar: :any,                 arm64_sequoia: "500fe7fdc2981ccddf4c12eac26eec5c3346989163d2088594907eb4af5d464b"
    sha256 cellar: :any,                 arm64_sonoma:  "a32e1b13a822cfb21c6edca3805f9f153cfdb255f2444e513853246e10b87219"
    sha256 cellar: :any,                 arm64_ventura: "bf6bcbba87e993c5fc23aa5418b34bed52f2d5f2b0f0ed9ceb9b9ff9c0b48a8a"
    sha256 cellar: :any,                 sonoma:        "6d68970cd73b53c2194cd6f58f562fe40db19a6f2585031775f300ab8dc32c6f"
    sha256 cellar: :any,                 ventura:       "2009975f2491b96b2654ee8445deaf0674bf46fdabaa76e486f040bbbcb3adb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "555a728fd178fd0a5d1ef144c9de23dc8e6b7ac3a7a86c89a224e2198580496c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7ad8944689b56b3ee991d3f0cc05582a812d75faf9645822332525574eda1ff"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~HASKELL
      foo =
        f1
        p1
        p2 p3

      foo' =
        f2 p1
        p2
        p3

      foo'' =
        f3 p1 p2
        p3
    HASKELL
    expected = <<~HASKELL
      foo =
          f1
              p1
              p2
              p3

      foo' =
          f2
              p1
              p2
              p3

      foo'' =
          f3
              p1
              p2
              p3
    HASKELL
    assert_equal expected, shell_output("#{bin}/fourmolu test.hs")
  end
end
