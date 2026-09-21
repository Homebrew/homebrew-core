class CfTerraforming < Formula
  desc "CLI to facilitate terraforming your existing Cloudflare resources"
  homepage "https://github.com/cloudflare/cf-terraforming"
  url "https://github.com/cloudflare/cf-terraforming/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "99403c002959138a4d4c3ff95030a0706963e1bf2cb7e776de78a30ab91eec57"
  license "MPL-2.0"
  head "https://github.com/cloudflare/cf-terraforming.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "21bf7e2a9922b7e098d926440bbd817817982db10042847f73c786a5d45bc6eb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "21bf7e2a9922b7e098d926440bbd817817982db10042847f73c786a5d45bc6eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "21bf7e2a9922b7e098d926440bbd817817982db10042847f73c786a5d45bc6eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "21bf7e2a9922b7e098d926440bbd817817982db10042847f73c786a5d45bc6eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f56c791cb09f5b6bf4b55c6c43f9f129ae07f7d832c880b48a26808355325419"
    sha256 cellar: :any,                 x86_64_linux:      "51537fdf729cdebc1bd121ed0484d975e1f5224f3235503786f8a8c4e975ab14"
  end

  depends_on "go" => :build

  def install
    proj = "github.com/cloudflare/cf-terraforming"
    ldflags = "-X #{proj}/internal/app/cf-terraforming/cmd.versionString=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cf-terraforming"

    generate_completions_from_executable(bin/"cf-terraforming", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cf-terraforming version")
    output = shell_output("#{bin}/cf-terraforming generate 2>&1", 1)
    assert_match "you must define a resource type to generate", output
  end
end
