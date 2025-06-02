class PolicyEngine < Formula
  desc "Unified Policy Engine"
  homepage "https://github.com/snyk/policy-engine"
  url "https://github.com/snyk/policy-engine/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e188113c2d3c25727943371153546ca818990b6125751b0f4f78171da847063b"
  license "Apache-2.0"
  head "https://github.com/snyk/policy-engine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "444f466414228ead13c746e6fc1cd7c0bd853d0d8ae89bbf0828332e05eb0e6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3b6f4e823932562da44865a3622cc540b62885db695bbfa7afe4742e22a558d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "514e1f79a8ec9574d5f89fae1ee53031241cc8f2e35c453909fbdab734b79d12"
    sha256 cellar: :any_skip_relocation, sonoma:        "06a6a3edbab4e855a22f8aad7bcd47691fdc39810b148dd26fbf53f25aa11fe6"
    sha256 cellar: :any_skip_relocation, ventura:       "e44c79e201b1a2586528715f7c504816bfe7859fa135b9811694d32fa40794f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c4275eb7fde7e9ebb38b9a613a029cded133aaf4d76e57586ad6d41cecbd6cd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/snyk/policy-engine/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"policy-engine", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/policy-engine version")

    (testpath/"infra/test.tf").write <<~HCL
      resource "aws_s3_bucket" "foo-bucket" {
        region        = "us-east-1"
        bucket        = "test"
        acl           = "public-read"
        force_destroy = true

        versioning {
          enabled = true
        }
      }
    HCL

    assert_match "\"rule_results\": []", shell_output(bin/"policy-engine run infra")
  end
end
