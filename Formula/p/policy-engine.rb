class PolicyEngine < Formula
  desc "Unified Policy Engine"
  homepage "https://github.com/snyk/policy-engine"
  url "https://github.com/snyk/policy-engine/archive/refs/tags/v1.1.8.tar.gz"
  sha256 "20df2dbcc8431835568bf97917e818596dcc0cc803f56636743f188fc7a93ac4"
  license "Apache-2.0"
  head "https://github.com/snyk/policy-engine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dd908f95562d2451ea3d3edce5760eb8a4ac252f89a013fee0a4249aa0abc2c1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dd908f95562d2451ea3d3edce5760eb8a4ac252f89a013fee0a4249aa0abc2c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dd908f95562d2451ea3d3edce5760eb8a4ac252f89a013fee0a4249aa0abc2c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "47c8f63313af7b7445f83c399b1ef0f146b6570bda6da8f9ccf790358cd6c00c"
    sha256 cellar: :any,                 x86_64_linux:      "61af8f200b52b583e3a875322a150799bbb265de7b6a26651a4af9cce3de9a76"
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
