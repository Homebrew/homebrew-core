class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "0bd808d9398c1dc191b55ccaf3bf053448fdfd9d86dcc47a3154cb271fafbefc"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1627d60002bea1ac333025a29b5d5e1ee0ca1661e4373af02f6bf92177642612"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1627d60002bea1ac333025a29b5d5e1ee0ca1661e4373af02f6bf92177642612"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1627d60002bea1ac333025a29b5d5e1ee0ca1661e4373af02f6bf92177642612"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2f869403056c546b8b661bdf10037f44a0526a7b46782432c0bea86e5b2d7ec5"
    sha256 cellar: :any,                 x86_64_linux:      "78c7373a0247a55b48beeea497e76b5f91561763c5dde76157041ef00d769641"
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
