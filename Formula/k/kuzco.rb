class Kuzco < Formula
  desc "Reviews Terraform and OpenTofu resources and uses AI to suggest improvements"
  homepage "https://github.com/RoseSecurity/Kuzco"
  url "https://github.com/RoseSecurity/Kuzco/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "5757797a436c8817137861bbf88ef2c9b492eacf4fec5b7badfdc50110d0942e"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Kuzco.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "828064bd9fb70c5de1bb73c6b0a2962160a3b1cdfdb1cae11a7a5fb714df4a56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "828064bd9fb70c5de1bb73c6b0a2962160a3b1cdfdb1cae11a7a5fb714df4a56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "828064bd9fb70c5de1bb73c6b0a2962160a3b1cdfdb1cae11a7a5fb714df4a56"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1651aaa2c42ca75c2f014d102a515ce52c5ea68b5382f29dc3c46e0e779a762"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f543fbf8dac52ad9e3367c9628d60e9c43841290dedb981369252007bc418fcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e260ce2a657884b2ae7439e127b71cd1b56b9bf7ca188eea7b122b5b80b5473"
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
