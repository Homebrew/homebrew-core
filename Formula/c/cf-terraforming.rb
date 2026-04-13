class CfTerraforming < Formula
  desc "CLI to facilitate terraforming your existing Cloudflare resources"
  homepage "https://github.com/cloudflare/cf-terraforming"
  url "https://github.com/cloudflare/cf-terraforming/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "2c734fc8d2a7cbe90cf6027634ef7822efd68570dee4f5d2878cd8a49eb048e2"
  license "MPL-2.0"
  head "https://github.com/cloudflare/cf-terraforming.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e93ec88b3189a64a77c0805b35d95a194a7912d04f64401ab71b0e38fadd7914"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e93ec88b3189a64a77c0805b35d95a194a7912d04f64401ab71b0e38fadd7914"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e93ec88b3189a64a77c0805b35d95a194a7912d04f64401ab71b0e38fadd7914"
    sha256 cellar: :any_skip_relocation, sonoma:        "86d8cf1b9b05f502f373a4c9e00d146a94e3be839123a1053544a4a2d7b027f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ae12af08c0543567168513cdd819bf6b45c8c33f88760f0a0d4a634f1ad34f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b392ebde697f31704e4cf26f52e27e9a82a8696654dc5eacdac9e6b66b8ece70"
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
