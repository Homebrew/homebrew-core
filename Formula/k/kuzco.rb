class Kuzco < Formula
  desc "Reviews Terraform and OpenTofu resources and uses AI to suggest improvements"
  homepage "https://github.com/RoseSecurity/Kuzco"
  url "https://github.com/RoseSecurity/Kuzco/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "a4c3d75467a73821fecb5ab79270f96f57cc9da3bdbbea8e36376f22e92544fd"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Kuzco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4df357c2c9fd7ffa3b8e9fb965ad18737d85b0ecb511395829cb4d6b2f9cd461"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4df357c2c9fd7ffa3b8e9fb965ad18737d85b0ecb511395829cb4d6b2f9cd461"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4df357c2c9fd7ffa3b8e9fb965ad18737d85b0ecb511395829cb4d6b2f9cd461"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4ae7b7d4615ea985cc61ae161472e9a32a08009f726fa3dbfd9d36c09c8e9f0"
    sha256 cellar: :any_skip_relocation, ventura:       "f4ae7b7d4615ea985cc61ae161472e9a32a08009f726fa3dbfd9d36c09c8e9f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf5d6462191ad449248bef603c5ecfb1bb11932b882be7d7f31c402c52ff5ca4"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    ldflags = "-s -w -X github.com/RoseSecurity/kuzco/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kuzco", "completion")
  end

  test do
    test_file = testpath/"main.tf"
    test_file.write <<~EOS
      resource "aws_s3_bucket" "cloudtrail_logs" {
        bucket              = "my-cloudtrail-logs-bucket"
        object_lock_enabled = true

        tags = {
          Name        = "My CloudTrail Bucket"
          Environment = "Dev"
          Region      = "us-west-2"
        }
      }
    EOS

    output = shell_output("#{bin}/kuzco recommend -t opentofu -f #{test_file} --dry-run")
    assert_match "version block", output

    assert_match version.to_s, shell_output("#{bin}/kuzco version")
  end
end
