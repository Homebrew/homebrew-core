class Doctl < Formula
  desc "Command-line tool for DigitalOcean"
  homepage "https://github.com/digitalocean/doctl"
  url "https://github.com/digitalocean/doctl/archive/refs/tags/v1.154.0.tar.gz"
  sha256 "9163b6d91b6d5b045eea61c13c99ae50e4b4e2862d629f95767da511069aa84d"
  license "Apache-2.0"
  head "https://github.com/digitalocean/doctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "963614430a6bbc3deab5b0953f10f680c207ab06f198bc6edd1a7f4f3c004682"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "963614430a6bbc3deab5b0953f10f680c207ab06f198bc6edd1a7f4f3c004682"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "963614430a6bbc3deab5b0953f10f680c207ab06f198bc6edd1a7f4f3c004682"
    sha256 cellar: :any_skip_relocation, sonoma:        "13d4dbed9d3a9874bbff234549959441cbee91cb25a9f14daacfa4c38a08a33a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ae23acc0120a360f8016b540480476f47c101a57587d72e20aeff010145686f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b913901d15e985820dddd93d5aebb4fa57b9d4325f509ad69e9cd96e49e58e6"
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
