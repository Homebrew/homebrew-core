class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "047e710bb085c71e9c16655faffd05884718bb0551797e9f827e686e1f2d0675"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "73e4bc7bdab7c14d55784770e2d31298d5f44ae0e9fb42aa7f6a46b0a06863d4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "73e4bc7bdab7c14d55784770e2d31298d5f44ae0e9fb42aa7f6a46b0a06863d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "73e4bc7bdab7c14d55784770e2d31298d5f44ae0e9fb42aa7f6a46b0a06863d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a72d7eef0acc0e1b32619e833f1dfd5fb2f8791f768c32f560f90815428287db"
    sha256 cellar: :any,                 x86_64_linux:      "06fb1aed02ed1386f9bb31f80e05c4ce79ccd7ad53ff6f158f5bc119d9063cf4"
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
