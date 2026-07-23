class PolicyEngine < Formula
  desc "Unified Policy Engine"
  homepage "https://github.com/snyk/policy-engine"
  url "https://github.com/snyk/policy-engine/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "fbb133fc5eeec783f147b6abc7658faab4e3f697df5c49d0ecbf77ecb42f92f8"
  license "Apache-2.0"
  head "https://github.com/snyk/policy-engine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f20b6f93b48b346baa7f1408564fcc60cb8b79d98e6032798826cb2e32d7de46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f20b6f93b48b346baa7f1408564fcc60cb8b79d98e6032798826cb2e32d7de46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f20b6f93b48b346baa7f1408564fcc60cb8b79d98e6032798826cb2e32d7de46"
    sha256 cellar: :any_skip_relocation, sonoma:        "5df9371d84b177cb3f092d104c478479166b3d7e8483f04791b7e14b9a84ffd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88b4a1806b2fac092963000a3fa88321f5ecafeb56c3f3333f336ffc4b9d80f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cda1bc0e74c78999259e87c915304487ff2d3f29b4919f076f4f28bbc2ba549f"
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
