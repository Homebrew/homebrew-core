class Fourmolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/fourmolu/fourmolu"
  url "https://github.com/fourmolu/fourmolu/archive/v0.12.0.0.tar.gz"
  sha256 "d665ce64a12c9408203151590bca151e25e3bf4faf832862df0a654962725891"
  license "BSD-3-Clause"
  head "https://github.com/fourmolu/fourmolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "357d7fa3b7e925ddc3a11cbb6cdd55c2ea3784e8aa9d98498f1f55cb835fd224"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c6344ed42647d529cc6e4fb4bb5856d6fb06c5c21e7cf57901552e4e1b33c2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03610cc5b4f373049895dabb0ae92587fc4d40006b8aea452b866e8eaa39a05f"
    sha256 cellar: :any_skip_relocation, ventura:        "41ec25db3a6e653e6278973e8be242d5c6339c7b9d83d75005d686d3ebb55869"
    sha256 cellar: :any_skip_relocation, monterey:       "7dcaa408b068adb624bf83f7a4d9e9fb8b0bf917c30d7dcbee8287ee842521ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "c39a2e50e86d70873402052c65cd9d3823dfc469f46d041cea2f839ba6af125d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4669acdab52a36c0409f9b484760f019ddfa26bd19b13a448aaabf4e9a66d01f"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~EOS
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
    EOS
    expected = <<~EOS
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
    EOS
    assert_equal expected, shell_output("#{bin}/fourmolu test.hs")
  end
end
