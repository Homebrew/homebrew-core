class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/refs/tags/v0.76.0.tar.gz"
  sha256 "3dce013753fe21f8f2fec7e6282cd998ed84cef70cd29ceb17237c3cb76851cf"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "812a6b19afd88de824061dcb856defe18e54e7ee3513a519f4bc8c8576129868"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08fa6c3ddcdca98ff7b046ac2e43a73cf2c2ecd8825bf8af9e3ff92f3ed95792"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01ea72745f1111d8574cd6f13f3a488c5c07e646f49de2c13291380546d3054b"
    sha256 cellar: :any_skip_relocation, ventura:        "9bdf1a0d0f9395701d819f41e2170099b45bf1e47c8fd6f1a037753b7b9d3bdf"
    sha256 cellar: :any_skip_relocation, monterey:       "eee3457c7ec796b3b5b6a9a90a65e5a277ac577370c4f1a34211601fe56c8912"
    sha256 cellar: :any_skip_relocation, big_sur:        "c26d46fa62808095332ed70ee3063147efaf9199bc4b322387192c9bd0c0fa21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca79e07f5787f386d6b1c592f9e4267b75e3b3a2b5c3b0ef412e116facad8316"
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
