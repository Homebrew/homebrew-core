class CfTerraforming < Formula
  desc "CLI to facilitate terraforming your existing Cloudflare resources"
  homepage "https://github.com/cloudflare/cf-terraforming"
  url "https://github.com/cloudflare/cf-terraforming/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "1842f2387aafcef4bf0c38ff4aea43f03de412823275223da4bbe099b5255f66"
  license "MPL-2.0"
  head "https://github.com/cloudflare/cf-terraforming.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51d1beef15ce96fee64146b4aa17939d8a1c0feada15bab887ab2a8ab4d22792"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51d1beef15ce96fee64146b4aa17939d8a1c0feada15bab887ab2a8ab4d22792"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51d1beef15ce96fee64146b4aa17939d8a1c0feada15bab887ab2a8ab4d22792"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a606299979d3481065d03fee096dc0cce0d01f5497f8cd346327d4f84f1e88c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53fac652a6e813dbd8ebaa1312c3e5397f5c8465b42d7b1aebe0b542176215d5"
    sha256 cellar: :any,                 x86_64_linux:  "5a0d79dfdc22eb7ed664064cd0a192c9314542fded9352abe4f11ac35a1dc445"
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
