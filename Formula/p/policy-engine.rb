class PolicyEngine < Formula
  desc "Unified Policy Engine"
  homepage "https://github.com/snyk/policy-engine"
  url "https://github.com/snyk/policy-engine/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "9034928e46c2aab8b1157e8b6bc9ccd38b6a05665875c70a5c06efa5fe047635"
  license "Apache-2.0"
  head "https://github.com/snyk/policy-engine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "daaccc0b03a1eee6bc51b886ffd736dd6cc0b9e7add8a09a1894773054f46688"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daaccc0b03a1eee6bc51b886ffd736dd6cc0b9e7add8a09a1894773054f46688"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daaccc0b03a1eee6bc51b886ffd736dd6cc0b9e7add8a09a1894773054f46688"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e79c0efadc0a0b232fabd90df1e412b0801bdc77a6c8f76bf1cb4a57f6c3ed1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f45004955ef27aed57898f88ff7a797830806154854f93cea6be8d208ef3ec9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcf983640b1bc85747ef73b12605ae040ce64dc6d22aff5fe2977b57f5128bdd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/snyk/policy-engine/pkg/version.Version=#{version}"
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
