class Kuzco < Formula
  desc "Reviews Terraform and OpenTofu resources and uses AI to suggest improvements"
  homepage "https://github.com/RoseSecurity/Kuzco"
  url "https://github.com/RoseSecurity/Kuzco/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "0ed043dcb031338c40054d91631522af3cd8a859534152b67757c0ac446a1edc"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Kuzco.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "257b62873665e901e8dd573154e0980b693d16011c5cf67bb6d55c3fe52f5f09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "257b62873665e901e8dd573154e0980b693d16011c5cf67bb6d55c3fe52f5f09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "257b62873665e901e8dd573154e0980b693d16011c5cf67bb6d55c3fe52f5f09"
    sha256 cellar: :any_skip_relocation, sonoma:        "b861e54182109ab679aacffe4a1d891b0749be87836833a1a8b49bbf25357af9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4ce2358cd9bb85125b58ee5c767f54cb910d7d956852184766c492eb7153bcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2c0c1cf10c9a3a8c0ffa27c4cc977738f6c55b08fd0c5da5def1276c1a449a7"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    ldflags = "-s -w -X github.com/RoseSecurity/kuzco/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kuzco", shell_parameter_format: :cobra)
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
