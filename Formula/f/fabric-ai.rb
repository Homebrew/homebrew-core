class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.278.tar.gz"
  sha256 "ca0ab05f317f6d18befe6398fa2c1d36ffa793f147a86208a0b2e34df38bc048"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdbc4a31a2b2d90b2e5b3b4348449be1075ae6394d50f731697e24d9edcc86c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdbc4a31a2b2d90b2e5b3b4348449be1075ae6394d50f731697e24d9edcc86c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fdbc4a31a2b2d90b2e5b3b4348449be1075ae6394d50f731697e24d9edcc86c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a0d02b7af50c54e1123d35cfd1925505db7d4227da77898960dc2a9000907a6"
    sha256 cellar: :any_skip_relocation, ventura:       "6a0d02b7af50c54e1123d35cfd1925505db7d4227da77898960dc2a9000907a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a532c497978f191d8d3210aa8bb65e29776fd72f606c597263babc441b36078c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end
