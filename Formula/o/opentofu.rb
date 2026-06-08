class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "c736126cea1f0067e046ef0172eb4ba2b39bcf1494d399e067b9e63e0f0d20d6"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0a446e946fea023ba221b4bfd6d7907ada772547e030dcda2c42f97ec73a585"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38d9d771fb21d3f63edd837e3326015297ba51d59a53271e2f6b3806e1745acb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b26e828bc5bea1daba81374cb7eb02d54b32811fd14990ae797af04615621399"
    sha256 cellar: :any_skip_relocation, sonoma:        "646c148cec175cb92955ed71ff0f00a939c4d7fca7be9c680b5f50dbbf45d5ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70c18c69cf32c65d889d26309d377008e6b20f937051744dd9bb17ec7a433c53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c53a00728ee2ccfaf8f1bb59dc661ac97b6b09bc207c0dc5bb3fd96f9933b37"
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
