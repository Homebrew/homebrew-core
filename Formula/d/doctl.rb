class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.158.0.tar.gz"
  sha256 "785762a48c08594281cdc18c03b44796ad7289ef9cbff803bcb0d0d2dd8a99a0"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "741d201ebad6ecddb4e6556933492146c353de858cad9f7f51fa794d0ad1bb3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "741d201ebad6ecddb4e6556933492146c353de858cad9f7f51fa794d0ad1bb3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "741d201ebad6ecddb4e6556933492146c353de858cad9f7f51fa794d0ad1bb3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d20c7e5ceb4cd2a438248c29b4573c9ee2d348055dabce206881df9cfef0090"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "308cdc2a7768898c5cb6544caa25d64229654bdb32cdc022cd0e23c8dab3ea4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4056018d14620e317ed15836a24becc693d33e80e07c329f63f6b9d2c9b5b18a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/digitalocean/doctl.Major=#{version.major}
      -X github.com/digitalocean/doctl.Minor=#{version.minor}
      -X github.com/digitalocean/doctl.Patch=#{version.patch}
      -X github.com/digitalocean/doctl.Label=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/doctl"

    generate_completions_from_executable(bin/"doctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "doctl version #{version}-release", shell_output("#{bin}/doctl version")
  end
end
