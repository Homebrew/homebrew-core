class Kuzco < Formula
  desc "Reviews Terraform and OpenTofu resources and uses AI to suggest improvements"
  homepage "https://github.com/RoseSecurity/Kuzco"
  url "https://github.com/RoseSecurity/Kuzco/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "4a3287d64f6298553214d0bd6a37de8eb45b55264350e50235ad118aa2a802c5"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Kuzco.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1fbd5d20af48d7c0afa0c4acad851995c5f1c75c1f31400580b899787a72df1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b5409f26f8fa308c1213f6ac2b0fb698d784ba6448725db0b9f5aafa5f6c37a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b5409f26f8fa308c1213f6ac2b0fb698d784ba6448725db0b9f5aafa5f6c37a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b5409f26f8fa308c1213f6ac2b0fb698d784ba6448725db0b9f5aafa5f6c37a"
    sha256 cellar: :any_skip_relocation, sonoma:        "99a7be91f9ea18236460fee519bba76e16125ed31d96cead83c60b6e5323d116"
    sha256 cellar: :any_skip_relocation, ventura:       "99a7be91f9ea18236460fee519bba76e16125ed31d96cead83c60b6e5323d116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "907e3ad58c62e126937aa44febd2c912ad9145643ac2197e737060158e767ce6"
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
