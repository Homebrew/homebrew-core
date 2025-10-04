class Kuzco < Formula
  desc "Reviews Terraform and OpenTofu resources and uses AI to suggest improvements"
  homepage "https://github.com/RoseSecurity/Kuzco"
  url "https://github.com/RoseSecurity/Kuzco/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "dcff9f78ba7f383899a8b368c1c2b777ea3de3634012193e80f9c0e528484e44"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Kuzco.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92ea2e24739100902ccbdd447c7f779c80d2206e4cc7c9109fa15b625bbb8d4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92ea2e24739100902ccbdd447c7f779c80d2206e4cc7c9109fa15b625bbb8d4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92ea2e24739100902ccbdd447c7f779c80d2206e4cc7c9109fa15b625bbb8d4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc0364b9f11c3dfcfee702960118e738295d22829df8fc8c6867e08c2100a2cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a14b76519f88eb799a979d2ee94e664640a435a06c5a9553d9a4e1d0a5a3236"
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
    assert_match "Unused attributes", output

    assert_match version.to_s, shell_output("#{bin}/kuzco version")
  end
end
