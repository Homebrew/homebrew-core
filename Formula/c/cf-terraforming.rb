class CfTerraforming < Formula
  desc "CLI to facilitate terraforming your existing Cloudflare resources"
  homepage "https://github.com/cloudflare/cf-terraforming"
  url "https://github.com/cloudflare/cf-terraforming/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "cd76f85a4a1664769521c870985ca12281c8c1c195d501430f80049ae59ed37d"
  license "MPL-2.0"
  head "https://github.com/cloudflare/cf-terraforming.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df8a464242d1631c2d600f78fbf17c6b294f5b413534e428de944b28d149ad47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df8a464242d1631c2d600f78fbf17c6b294f5b413534e428de944b28d149ad47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df8a464242d1631c2d600f78fbf17c6b294f5b413534e428de944b28d149ad47"
    sha256 cellar: :any_skip_relocation, sonoma:        "46e00a47a7505787324b4d886da4ad7c61068d92c960cc0fc7033f7785dc8461"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a77b463d126089f4eda1be2dd354d98a41984845b7bb4950b289cd512e11843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dea4ee0dec5c2b53e6a9e48e30633ec3f659c1d07b75e16c2db71ba5f5a1a36"
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
