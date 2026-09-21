class PolicyEngine < Formula
  desc "Unified Policy Engine"
  homepage "https://github.com/snyk/policy-engine"
  url "https://github.com/snyk/policy-engine/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "50bef12330c2b2fdefa21958af76f6109c4bf9ea7ff7d5b26bf3a9c60c9b727a"
  license "Apache-2.0"
  head "https://github.com/snyk/policy-engine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "774b61d471e1c9503f942e6ceeacb465f8056ab74d7ce5da765efb187840c10d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "774b61d471e1c9503f942e6ceeacb465f8056ab74d7ce5da765efb187840c10d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "774b61d471e1c9503f942e6ceeacb465f8056ab74d7ce5da765efb187840c10d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3a4cc8fe2010bdebc310f29b65329fe392f5cda532a46aa020dfe36aba8522ce"
    sha256 cellar: :any,                 x86_64_linux:      "97faddec79127a883a1cee481c6355e8a61f9894054a210f2a1b526ff15b96c4"
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
