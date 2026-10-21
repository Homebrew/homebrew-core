class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "a1acc98f69cb41b1096d319c72d1255dfe1939b1333989758f15a0eb6c81b283"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b580bd8e13dfe8258d3b8ca5ec6b7545d883bc879e9d13fd9c65c697507e98fd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b580bd8e13dfe8258d3b8ca5ec6b7545d883bc879e9d13fd9c65c697507e98fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b580bd8e13dfe8258d3b8ca5ec6b7545d883bc879e9d13fd9c65c697507e98fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1d0983b7ebda3bb7a2a110065203fc3c37a9c9931f87624619afc4a7e120dad8"
    sha256 cellar: :any,                 x86_64_linux:      "b33a122a54cb53bad56bcfad18e761770ec4f395419120300601e48a9db04a6d"
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
