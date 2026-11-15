class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://github.com/openclaw/gogcli/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "b35008c91e52da485c031f93b87a960896de668618dbd003ef13f288feff8be9"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8094030393a8af1e0952172288493279c9e19885dbd2c11c377d175f835a1bb0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4eb7771a686ac4f604a1c2762d23aea323b44f282c2a0692dc25e24dc80273ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b50e887f574d19e17d5d88596f64c89ab3eb87d9d30b2757bcd6846dff8bbee1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "82d4963547b67cca3f0449e9d2ded69a319b00af1214ab74821889e445d62856"
    sha256 cellar: :any,                 x86_64_linux:      "59d3bc6166fdc6918e13afce5710454cbcc10eca404b7de4f52ba8f15eac46f3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/steipete/gogcli/internal/cmd.version=#{version}
      -X github.com/steipete/gogcli/internal/cmd.commit=#{tap.user}
      -X github.com/steipete/gogcli/internal/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gog"), "./cmd/gog"

    generate_completions_from_executable(bin/"gog", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gog --version")

    ENV["GOG_ACCOUNT"] = "example@example.com"
    output = shell_output("#{bin}/gog drive ls 2>&1", 10)
    assert_match "OAuth client credentials missing", output
  end
end
