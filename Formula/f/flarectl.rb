class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/refs/tags/v0.92.0.tar.gz"
  sha256 "e4e654d880cc8bf45b69242091236a1db8fd43056c589f0669a8aaffe2ea6d05"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9b2098663147702337e8c3ed22e9719539efe327999ca7556e748591f44a4c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "528698eb96596c0dc660cdb034081f9d740fc949f5a4e04524349bc245ce8794"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "466cacae06654d293503423fec1bb5e64c6fd49643a3b4a7885304e082263554"
    sha256 cellar: :any_skip_relocation, sonoma:         "60cd4ed725869506bc60d584e90e24181a05edce2685e333cb28c352bc0dc15d"
    sha256 cellar: :any_skip_relocation, ventura:        "d16d32c9e3e23b96227f7387a7b69b06f4330855167b251a757ff1aa45cc66ef"
    sha256 cellar: :any_skip_relocation, monterey:       "0e9e40f85e61b66805e6a111c6ec06550aa77e4af4d7d0175950fc918a2cf52d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "689a4ba084adbe857a5fd892a990b10cdd43bf79aedc2cfb25bc51a53950ca4a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
