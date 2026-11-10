class CfTerraforming < Formula
  desc "CLI to facilitate terraforming your existing Cloudflare resources"
  homepage "https://github.com/cloudflare/cf-terraforming"
  url "https://github.com/cloudflare/cf-terraforming/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "62c7186f2c83b8065d0b3429635d1947f4b8271e44ff76acb9a7a0726bb61517"
  license "MPL-2.0"
  head "https://github.com/cloudflare/cf-terraforming.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "363d3c1b2f9aafe4f0b5022231547692d3fb4075e99d47f85253aeeba434cb3d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "363d3c1b2f9aafe4f0b5022231547692d3fb4075e99d47f85253aeeba434cb3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "363d3c1b2f9aafe4f0b5022231547692d3fb4075e99d47f85253aeeba434cb3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2e824b50484726ba8f7ed304b758844e1251dc6e32705890f5861acacc3df689"
    sha256 cellar: :any,                 x86_64_linux:      "64892506ac3ce71a732b3f0bc806328534b32170438113ef4c5dd4aaabc02744"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    proj = "github.com/cloudflare/cf-terraforming"
    ldflags = "-X #{proj}/internal/app/cf-terraforming/cmd.versionString=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cf-terraforming"

    generate_completions_from_executable(bin/"cf-terraforming", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cf-terraforming version")
    output = shell_output("#{bin}/cf-terraforming generate --token dummy 2>&1", 1)
    assert_match "you must define a resource type to generate", output
  end
end
