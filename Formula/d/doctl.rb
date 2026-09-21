class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://docs.digitalocean.com/reference/doctl/"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.169.0.tar.gz"
  sha256 "cc52e46897ad79f9965b4736116e48412711426e298240ed0ae6fe392aedc18a"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "145d29379234841c6849304110af9194297ff56f6ca1d0438f806e6a5e285dc7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "145d29379234841c6849304110af9194297ff56f6ca1d0438f806e6a5e285dc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "145d29379234841c6849304110af9194297ff56f6ca1d0438f806e6a5e285dc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d8b38e26d2d38ae41978c4c38355e5ea6cc2a59d54827605c064dc58cc0109fa"
    sha256 cellar: :any,                 x86_64_linux:      "1b425ddffaf3a67e7bb1a64969d9da909d41b839421c9f80891e62ae2a6b86cc"
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
