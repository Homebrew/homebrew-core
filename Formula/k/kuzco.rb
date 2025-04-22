class Kuzco < Formula
  desc "Reviews Terraform and OpenTofu resources and uses AI to suggest improvements"
  homepage "https://github.com/RoseSecurity/Kuzco"
  url "https://github.com/RoseSecurity/Kuzco/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "03d8a3bd5265be55e7d3cc862eeba7672bd27f04bffab2f14824ebf98e35ac7f"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Kuzco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "843597dc532c472bbc088673a68e60a58902e9084dbdc2c115ad29cf45a48e2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "843597dc532c472bbc088673a68e60a58902e9084dbdc2c115ad29cf45a48e2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "843597dc532c472bbc088673a68e60a58902e9084dbdc2c115ad29cf45a48e2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0350b15b9784103662da14cf4bb05684ca2b48d2e85124b5d43198e4c41f024e"
    sha256 cellar: :any_skip_relocation, ventura:       "0350b15b9784103662da14cf4bb05684ca2b48d2e85124b5d43198e4c41f024e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e40231c893f224e21d1d430c7286c2adceadf4cff0eb12d2322d4c7bbcbd9f6"
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
