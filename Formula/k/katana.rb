class Katana < Formula
  desc "Crawling and spidering framework"
  homepage "https://github.com/projectdiscovery/katana"
  url "https://github.com/projectdiscovery/katana/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "eface6334d46ad8235e647bc5c6853c4defd34dfc2c8703a5fb52824025a2d59"
  license "MIT"
  head "https://github.com/projectdiscovery/katana.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3987951ad50ff7dccda0c9ca1cb33070e288a491b83c06204459e5f847df18d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3987951ad50ff7dccda0c9ca1cb33070e288a491b83c06204459e5f847df18d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3987951ad50ff7dccda0c9ca1cb33070e288a491b83c06204459e5f847df18d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c1f22ee6ba3170ddaa4282dfb1365da5c88d0314f16794900faa326e59d115b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03c5c6bb8f2986110343989ba12118807f186d0b1bd187bdc6b56472ace0f535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1947661e2533c9dc13a648be10fe0c898eb522f4a1a1435810014cfa152a1f15"
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

    ldflags = %W[-X github.com/projectdiscovery/katana/internal/runner.version=v#{version}]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/katana"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/katana -version 2>&1")
    assert_match "Started standard crawling", shell_output("#{bin}/katana -u 127.0.0.1 2>&1")
  end
end
