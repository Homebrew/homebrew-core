class Katana < Formula
  desc "Crawling and spidering framework"
  homepage "https://github.com/projectdiscovery/katana"
  url "https://github.com/projectdiscovery/katana/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "490f23c25daeea0ccf93268a81b4a89ba84ec43ac2bf6dc988392ec3a65d9329"
  license "MIT"
  head "https://github.com/projectdiscovery/katana.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dec77e1c8dfff87af921ad817adaa35430a6906935c51ced600cdace4fa6fe25"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dec77e1c8dfff87af921ad817adaa35430a6906935c51ced600cdace4fa6fe25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dec77e1c8dfff87af921ad817adaa35430a6906935c51ced600cdace4fa6fe25"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "699c15d47970d5462dd593ba30cfb61e5f1151295a6d2abe8ec5477a2e84670c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0d1b834047bfaf57c4f6335e53b8f882cc5d1f59832d7452a2e2276a47b67c35"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"

    # Replace self-update with a notice; brew manages updates.
    inreplace "internal/runner/banner.go" do |s|
      s.gsub! 'updateutils "github.com/projectdiscovery/utils/update"',
              '_ "github.com/projectdiscovery/utils/update"'
      s.gsub! 'updateutils.GetUpdateToolCallback("katana", version)()',
              'gologger.Info().Msgf("Run `brew upgrade katana` to update.")'
    end

    ldflags = %W[-X github.com/projectdiscovery/katana/internal/runner.version=v#{version}]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/katana"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/katana -version 2>&1")
    assert_match "Started standard crawling", shell_output("#{bin}/katana -u 127.0.0.1 2>&1")
  end
end
