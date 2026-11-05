class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "047e710bb085c71e9c16655faffd05884718bb0551797e9f827e686e1f2d0675"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c00700b8d150a9bd694edb6003a719f79f38fe5c130354d09e79c3bddd7a4ead"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c00700b8d150a9bd694edb6003a719f79f38fe5c130354d09e79c3bddd7a4ead"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c00700b8d150a9bd694edb6003a719f79f38fe5c130354d09e79c3bddd7a4ead"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "99d073ed5bfdd1e13f075b5fb682541b183389bd1b40298927c9cb407d714bf6"
    sha256 cellar: :any,                 x86_64_linux:      "d5af3871aef37e187b03a5876d70fcca19c8b4f19fe5e29ef1d7e3252084a8cb"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
