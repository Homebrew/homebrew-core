class CfTerraforming < Formula
  desc "CLI to facilitate terraforming your existing Cloudflare resources"
  homepage "https://github.com/cloudflare/cf-terraforming"
  url "https://github.com/cloudflare/cf-terraforming/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "5109ba7f50a40864eb15ab554ae0b74aa3ac5009591c229c6b1b5079d363be24"
  license "MPL-2.0"
  head "https://github.com/cloudflare/cf-terraforming.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fde49d190699b9a034aae7045bd769339d84631861b7ec973062b21a0b823952"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fde49d190699b9a034aae7045bd769339d84631861b7ec973062b21a0b823952"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fde49d190699b9a034aae7045bd769339d84631861b7ec973062b21a0b823952"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca59f4d787cb32a5043f2e5d076b6364f9d7dcba4a0152d241ec9235856076b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43948d3b9f21b2f498f2f4b7b9fd68f8641d15a5e7352aeaefe9b65790217809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c51ffb1f4b7c228610578d43a63aa0c4cfc69b4f4be83bb255e1ff2065dd303"
  end

  depends_on "go" => :build

  def install
    proj = "github.com/cloudflare/cf-terraforming"
    ldflags = "-s -w -X #{proj}/internal/app/cf-terraforming/cmd.versionString=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cf-terraforming"

    generate_completions_from_executable(bin/"cf-terraforming", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cf-terraforming version")
    output = shell_output("#{bin}/cf-terraforming generate 2>&1", 1)
    assert_match "you must define a resource type to generate", output
  end
end
