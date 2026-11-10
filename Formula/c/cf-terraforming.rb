class CfTerraforming < Formula
  desc "CLI to facilitate terraforming your existing Cloudflare resources"
  homepage "https://github.com/cloudflare/cf-terraforming"
  url "https://github.com/cloudflare/cf-terraforming/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "62c7186f2c83b8065d0b3429635d1947f4b8271e44ff76acb9a7a0726bb61517"
  license "MPL-2.0"
  head "https://github.com/cloudflare/cf-terraforming.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0b0a73e0b93e3453ef0054cf7b121411ff829413cd28c0939ee34fc6a5b3e2f8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0b0a73e0b93e3453ef0054cf7b121411ff829413cd28c0939ee34fc6a5b3e2f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0b0a73e0b93e3453ef0054cf7b121411ff829413cd28c0939ee34fc6a5b3e2f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d1467a9b2fd8f23ea8614c4c6daec8fb31cbbf2210a56e53c6be2a9bdecf18e1"
    sha256 cellar: :any,                 x86_64_linux:      "e0aabd07bbe28358d1ab243ff65ae9fa667f24e7dbf775a4ba8f2544bbd27a31"
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
