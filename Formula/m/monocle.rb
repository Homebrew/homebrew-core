class Monocle < Formula
  desc "See through all BGP data with a monocle"
  homepage "https://github.com/bgpkit/monocle"
  url "https://github.com/bgpkit/monocle/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "1940d5c880a18e1839d327a87abdf29c3ec5ab95c45fcfd76b71f60ae2274ec5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "940f0e1e5c2432c7d4d7592ea6a0fc5e8744badf48bda9e2e759fd1e51822b8b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fc224ccbb2c93efef5e3698dfb6a834c1ce7220b1d1ec1d1bd0b19f879038626"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "13401f7a783866d6d809bd0e5acaa7698a0b260081390359aa475b51c76b2dbb"
    sha256 cellar: :any,                 arm64_linux:       "a0a7c2664e711cadce5d50198433a332c860bbbf9d94c10eb0ea92febecc60a8"
    sha256 cellar: :any,                 x86_64_linux:      "2ae063c69a7339aa13d500f7c9f980b2b301af49c30c81aa794cf7be6712f54c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/monocle time 1735322400 --simple")
    assert_match "2024-12-27T18:00:00+00:00", output
  end
end
