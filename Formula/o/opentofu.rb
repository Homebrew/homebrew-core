class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "d33c3c8ec139abae4c45e8a4187f1400032c8441a2eea4f976d2f16cdb5ec9f4"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cbda6f7e24b6043a21920cc05078ff95b2b28f916ea2ddf58703de4a0dd6651"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a557303bd45cde63c74ef3493e1b7045d44dcd5d1fbc2f79fae27ae9faf9218"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0920b2456a77c602d33042d1171146cb95c9ff6b31e58e9778036d12ffca581"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecc30dc752a8a1a9504e88e53db9472e8578eb7c166158df0b5ba86c18c32180"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abfc6481880c574ea7f80e59c2df8c281ad35bf574248c943a51d9dec43bcb24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e51bad4e12123afc45961d964125fddb46e7c271f0f62a49496b9b349cc3077"
  end

  depends_on "go" => :build

  conflicts_with "tenv", "tofuenv", because: "both install tofu binary"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X github.com/opentofu/opentofu/version.dev=no"
    system "go", "build", *std_go_args(output: bin/"tofu", ldflags:), "./cmd/tofu"
  end

  test do
    (testpath/"minimal.tf").write <<~HCL
      variable "aws_region" {
        default = "us-west-2"
      }

      variable "aws_amis" {
        default = {
          eu-west-1 = "ami-b1cf19c6"
          us-east-1 = "ami-de7ab6b6"
          us-west-1 = "ami-3f75767a"
          us-west-2 = "ami-21f78e11"
        }
      }

      # Specify the provider and access details
      provider "aws" {
        access_key = "this_is_a_fake_access"
        secret_key = "this_is_a_fake_secret"
        region     = var.aws_region
      }

      resource "aws_instance" "web" {
        instance_type = "m1.small"
        ami           = var.aws_amis[var.aws_region]
        count         = 4
      }
    HCL

    system bin/"tofu", "init"
    system bin/"tofu", "graph"
  end
end
