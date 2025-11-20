class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.10.7.tar.gz"
  sha256 "0038ca3064d90ac1c390a168539e731331f0ac80eaffd8fcaecac586790cf306"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1f5a125f31912e8f7d243eccdf189a1aad053c9fe53407799606580078a05db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1f5a125f31912e8f7d243eccdf189a1aad053c9fe53407799606580078a05db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1f5a125f31912e8f7d243eccdf189a1aad053c9fe53407799606580078a05db"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2b107a94d6a56e80f5c81af3ba7f4683d69fd7811f25b2d222edb0340692fb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bfe8080434646faa280db8393a540038bc45445ce390c72e3eab613385b0f4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b2ce2a6b1777bebcec8a8dd50fd3df0c8a22509fc966f3edc1c66ca81207d3d"
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
