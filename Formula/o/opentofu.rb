class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "bb79b27e586913f301ecf57e9aaac008582cc133a30c424d6775c5253f2acbeb"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "718fbcaa3077f1de2a6a7f4b5d2451d9b4dd5e325e476e917a2d189f04ada6d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e28d00720faba9d158a5b0e64b0d94a6cba0cc56db4f498f8198a283e8b9f462"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c12376f0672c68d5729f14bfc534c07dc78b08f0c1c1b47a71a71a4e86011018"
    sha256 cellar: :any_skip_relocation, sonoma:        "e16c927c56ef7c745560a2681307b4a81467267dbe2a0ea8081b7b6a3b5d02c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe09486af2580aca9cf1b139bf00ef61667fd1d81953b42ae98e0a4ecda67917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "107d31b4e9ed6c53bc27451745e7d02b95b6167b7139424ead07b8d48f9e15e6"
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
