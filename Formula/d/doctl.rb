class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "6580723fde863f0a4a3cfd32b25392d26bd5a58050452a1330d8e8eafca59350"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0ebb00f4e86167723ae552e8eecd7b7631ebacc1f3877d09536ead52b448a0d3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0ebb00f4e86167723ae552e8eecd7b7631ebacc1f3877d09536ead52b448a0d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0ebb00f4e86167723ae552e8eecd7b7631ebacc1f3877d09536ead52b448a0d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4524b3dc829a7dd514c42267b6b126199e651b6f4da8e6e2ac01412608729f28"
    sha256 cellar: :any,                 x86_64_linux:      "d80584c271fd462cc3ac8f6cfd915ce6cadc46c807e5b8a9fd769b1cc61aabbf"
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
