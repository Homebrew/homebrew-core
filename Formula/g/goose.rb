class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/refs/tags/v3.29.0.tar.gz"
  sha256 "267124956365ab3ed32ec9e36f4f341050916ed69fd2c4fbfc42355bb7fbf66f"
  license "MIT"
  head "https://github.com/pressly/goose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d3c8dd6aa72f6cec81952d77ad30116861c205c9e919bdac9126aeeddead1bd0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "50eb1432ed5389f0cefc21f2164af8c8efa7be958498a780cf7e371da5d522c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "556909e14ae4ef7648eb4fc4427ee2b92c14b71edd8b6e2922962c46c254acfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "91d663baf463c6e09f1ecc5d99dda79d23faa1450d7ef80b28780329b61dc8ec"
    sha256 cellar: :any,                 x86_64_linux:      "3c0e997c25b1ccf4bf1321029c73f6090225057ef3aed18176569251fd8d0404"
  end

  depends_on "go" => :build

  conflicts_with "block-goose-cli", because: "both install `goose` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X main.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1", 1)
    assert_match "goose run: failed to collect migrations", output

    assert_match version.to_s, shell_output("#{bin}/goose --version")
  end
end
