class Kuzco < Formula
  desc "Reviews Terraform and OpenTofu resources and uses AI to suggest improvements"
  homepage "https://github.com/RoseSecurity/Kuzco"
  url "https://github.com/RoseSecurity/Kuzco/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "e3c26877b0fa5dae633e81674d88f30d148a0b77d627cd6777c7d2825cc8062f"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Kuzco.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95487a1522a341d29b92bd5c445a4dccfe1044b2ed98f9a7126223357b0084cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95487a1522a341d29b92bd5c445a4dccfe1044b2ed98f9a7126223357b0084cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95487a1522a341d29b92bd5c445a4dccfe1044b2ed98f9a7126223357b0084cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "a31629ad0686c63c37142d6933c52429eb83785f9e7473c09feeeb5f10fc7c2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a88f63be38154165a86ad19dc078bbecb012d395625b3b69fa712408b9b2d45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d94364db4bf83f55afdd7fe9e3dde36774ccf8363f87f32f56d12bf7440896a8"
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
