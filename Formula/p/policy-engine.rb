class PolicyEngine < Formula
  desc "Unified Policy Engine"
  homepage "https://github.com/snyk/policy-engine"
  url "https://github.com/snyk/policy-engine/archive/refs/tags/v1.1.6.tar.gz"
  sha256 "294356f456510ed2d16ed30374d34855185277740cf1f818c4ddb660d98a1161"
  license "Apache-2.0"
  head "https://github.com/snyk/policy-engine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1fb7f4631fbea222793c24457fd17b6e09850ff21c963e58d7bb330123f779b1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6f7d070a9d470171f9b2967520ca63c3768b99c582c670907cbee82f8a0019cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "155ea9ec2ed7466a50ba4f7ef4dbc640feb095725363389beb7ae62d5d03609e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9af8556f4cb1b8b3a8b0354a1d7d5d9319ac4c5e0f87734b3da84a998734d928"
    sha256 cellar: :any,                 x86_64_linux:      "e88c2e9cc2947ffe07585ebe26f9f4d367ca076dcf4fbc2a405f735414b2c2a4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/snyk/policy-engine/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"policy-engine", shell_parameter_format: :cobra)
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

    assert_match "\"rule_results\": []", shell_output("#{bin}/policy-engine run infra")
  end
end
