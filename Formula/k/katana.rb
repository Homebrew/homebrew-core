class Katana < Formula
  desc "Crawling and spidering framework"
  homepage "https://github.com/projectdiscovery/katana"
  url "https://github.com/projectdiscovery/katana/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "c3518fabdc2a59e579e8286324d7be495972f71f7d672ff112f01239aa9f81ce"
  license "MIT"
  head "https://github.com/projectdiscovery/katana.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b53dc2653fd4eae2d0e7699e2bc4fe4752bbec77fc7ccb09a6d86af69809b434"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7ee984f935a8fb7088a6b198ff9f1a0c2e716a5969f2cda95ac9d411b1a37ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3743ea05922ee8b5f7ec130f8cab1455545708120c1300f9ef162eff55d48c6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e63b6a315bfbeed73431159a5f4c38abd7fd2fc0d7953c033e3c145ad1d396a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6808287543212b5a02cb27cfaf21d7bb3971bd07c0c23bc5d8b40c9a47cb5e3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7e18bfc230e404df821a890b8aedd60550bf93bc0d2a651791e382b03e51420"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    # Replace self-update with a notice; brew manages updates.
    inreplace "internal/runner/banner.go" do |s|
      s.gsub! 'updateutils "github.com/projectdiscovery/utils/update"',
              '_ "github.com/projectdiscovery/utils/update"'
      s.gsub! 'updateutils.GetUpdateToolCallback("katana", version)()',
              'gologger.Info().Msgf("Run `brew upgrade katana` to update.")'
    end

    ldflags = %W[
      -s -w
      -X github.com/projectdiscovery/katana/internal/runner.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/katana"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/katana -version 2>&1")
    assert_match "Started standard crawling", shell_output("#{bin}/katana -u 127.0.0.1 2>&1")
  end
end
