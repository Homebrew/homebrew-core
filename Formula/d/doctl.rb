class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "b928dce4609de6c1a3b9098792a0ea6dc43d380ba2833fb3e5032410881bce24"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "daefd846037e4ffe5a9d8b31ece9945a3c63e2792448ba6d99572f9b3473c7cf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "daefd846037e4ffe5a9d8b31ece9945a3c63e2792448ba6d99572f9b3473c7cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "daefd846037e4ffe5a9d8b31ece9945a3c63e2792448ba6d99572f9b3473c7cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5c6cf4d932174b924a531cb278d409ec36c40587520a03fac9d6d57bfb8b30e6"
    sha256 cellar: :any,                 x86_64_linux:      "21b0388e66fc6c0322b16b58bae3f114d2efcf6c673046452c816e8f18bca14c"
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
