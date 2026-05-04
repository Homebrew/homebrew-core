class Katana < Formula
  desc "Crawling and spidering framework"
  homepage "https://github.com/projectdiscovery/katana"
  url "https://github.com/projectdiscovery/katana/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "c3518fabdc2a59e579e8286324d7be495972f71f7d672ff112f01239aa9f81ce"
  license "MIT"
  head "https://github.com/projectdiscovery/katana.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0a6fce7b767f7ec181a292a7b903787335e70e855f50083c3f0a29dfa2a3eb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0a6fce7b767f7ec181a292a7b903787335e70e855f50083c3f0a29dfa2a3eb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0a6fce7b767f7ec181a292a7b903787335e70e855f50083c3f0a29dfa2a3eb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ab6b7831a1a8a54b76d434e099bfac6bdf44cd327a8e0483abd74a7bc36367f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1fc83c8b82222e763a393e635593f38262c5be1b507e5053644663ab3bca698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dcb986f3b40d99ba10228edceb8e8893312e9463933492534b050e4973ee0d9"
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
