class Kuzco < Formula
  desc "Reviews Terraform and OpenTofu resources and uses AI to suggest improvements"
  homepage "https://github.com/RoseSecurity/Kuzco"
  url "https://github.com/RoseSecurity/Kuzco/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "65523690293b640bc2196d0276f31f264d0e8499d074dd7aecc893c9769260d2"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Kuzco.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26eece27906eb49889a1b76d70603f685477b22a2495775a404dc22d09d2ca5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26eece27906eb49889a1b76d70603f685477b22a2495775a404dc22d09d2ca5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26eece27906eb49889a1b76d70603f685477b22a2495775a404dc22d09d2ca5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "557afc5d2c6de2a01cf1aae676cb080fd7070a7b71e94ad90269c7d9bac0e229"
    sha256 cellar: :any_skip_relocation, ventura:       "557afc5d2c6de2a01cf1aae676cb080fd7070a7b71e94ad90269c7d9bac0e229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff3aa0de79900251e6d627f8c368bb35678e3dca7f3b71fc33ce76871d2bd41a"
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
