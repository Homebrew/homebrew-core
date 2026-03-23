class PolicyEngine < Formula
  desc "Unified Policy Engine"
  homepage "https://github.com/snyk/policy-engine"
  url "https://github.com/snyk/policy-engine/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "b90e6cd1c4acca844a73cb376fabd698d3c06536346d9e4067abe4782edc58b9"
  license "Apache-2.0"
  head "https://github.com/snyk/policy-engine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e511473901b94df785c2fab82f2358a33bf47f968f2f8d64191f638fb913c78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e511473901b94df785c2fab82f2358a33bf47f968f2f8d64191f638fb913c78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e511473901b94df785c2fab82f2358a33bf47f968f2f8d64191f638fb913c78"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6024a86d4107fbd998256f4f348de5175625dcf7672ba4c0d1b6f89f534a9c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bfec98fe5591ffe78ebc6b58969aaea807e16db96e33241b9b5afb306201c5ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fac74cbeeb0bf49f1e661e2f95c9d877505c80f7407325e1bef65e431fda413b"
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
