class PolicyEngine < Formula
  desc "Unified Policy Engine"
  homepage "https://github.com/snyk/policy-engine"
  url "https://github.com/snyk/policy-engine/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "1bcff9b335404a5c505887208ea1a1d4d9fed73af757889ba3594525bfded643"
  license "Apache-2.0"
  head "https://github.com/snyk/policy-engine.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a7b6e5da094097583ac46a181aab8f200f60f302d1f8d976910cfa3b9aa0b3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "140f936020aef4bec9555f01b75d4efc2bbe7e4cf24aceda756ec9ba466328a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "140f936020aef4bec9555f01b75d4efc2bbe7e4cf24aceda756ec9ba466328a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "140f936020aef4bec9555f01b75d4efc2bbe7e4cf24aceda756ec9ba466328a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "828e03e6ac7d701c9a294bb80c58842888b6dc281e883bed99973c0c8d0d1a7f"
    sha256 cellar: :any_skip_relocation, ventura:       "828e03e6ac7d701c9a294bb80c58842888b6dc281e883bed99973c0c8d0d1a7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c57f3894e5318ef5241a4e7785ffffb40c3add087859c20485c686b02f5b760"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d6c08b38966d9334e76d04d8a023781430c3fbac95b06ee55abae297eb3f081"
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

    assert_match "\"rule_results\": []", shell_output("#{bin}/policy-engine run infra")
  end
end
