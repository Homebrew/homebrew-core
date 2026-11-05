class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://github.com/openclaw/gogcli/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "b35008c91e52da485c031f93b87a960896de668618dbd003ef13f288feff8be9"
  license "MIT"
  head "https://github.com/openclaw/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b2ced1fdf3b061259a1c116cdeb5082c3fdb108b847d12f6d2c209122530f43c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bee49873bb881e9e85b5567646c830b6aae1242416eb846ea48534d1f12f03c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fc2ee87154e13315e097fe51608698efa53d610aeed4cf79861a60d89d31fc16"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8a36a4b7330533af459cccb94b78834e8621a40e651b85ce53818f7276b81d74"
    sha256 cellar: :any,                 x86_64_linux:      "e9593fc0cdff650fa45ae94e6f2472789b2ffca1724c45922e2dcf6f2b250f91"
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
