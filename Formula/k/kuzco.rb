class Kuzco < Formula
  desc "Reviews Terraform and OpenTofu resources and uses AI to suggest improvements"
  homepage "https://github.com/RoseSecurity/Kuzco"
  url "https://github.com/RoseSecurity/Kuzco/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "e3c26877b0fa5dae633e81674d88f30d148a0b77d627cd6777c7d2825cc8062f"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Kuzco.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b9aa3c556ffc4a734b8b27a37879ac6be4380bd570e6f76c3f1f8257b79103a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b9aa3c556ffc4a734b8b27a37879ac6be4380bd570e6f76c3f1f8257b79103a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b9aa3c556ffc4a734b8b27a37879ac6be4380bd570e6f76c3f1f8257b79103a"
    sha256 cellar: :any_skip_relocation, sonoma:        "171c5cbd75d672fd5a745ef528aa505d72aad75e855c67dbe61f41cdedcc8716"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d11be849bffbdb7885482db5b8bc3bd81cc9b419b24d5fccc67f4a196e0d0d5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24bb1c8a705ed714836451cb45e50f5f97647fd25eccb6a88d42a864fb44da7a"
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
