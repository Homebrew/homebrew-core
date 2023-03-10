class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.22.1.tar.gz"
  sha256 "c30e8d968af4a99a2fb46ebd5bc448dc951153d2c17d3c5907f5ccf26cdd81b3"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8fe2610a650dad58c8988843ff3c40f69f451051e3087ae9a2c925166228067"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e3638dbed4519497f63f15cdf3003ae8851180860e9ee9a3fa3c08405829b2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ab362f47bfcae19a680f26e3abf6199ad3e05cf824ce3b3e31fd7edff632c6b"
    sha256 cellar: :any_skip_relocation, ventura:        "d4e131a77b02596028db19d287d38ed01fd98b640051981006518352a2f78bad"
    sha256 cellar: :any_skip_relocation, monterey:       "08e74594b531f4123a7bd9baa9580c7544a3242ac54ac3bb97100b9d3d3e5526"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f8b8c2a081c7991f2e4bf96ec350be191da61d9dede29376204e0add89082d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41fb6e2d570681a3f3ed1d9f93d7405aca81aff99f80b399fbd1156ef018bb8d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
