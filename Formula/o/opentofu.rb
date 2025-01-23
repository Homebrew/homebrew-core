class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "95234f00bb8a6d73bcd3f3920e376a32189004df3aaf26cb95917cec5441f8a8"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6c1fcc307e7c4d8cf2f5cd0daf1496a05a16cce15c1f3bc677c62ce7484be96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6c1fcc307e7c4d8cf2f5cd0daf1496a05a16cce15c1f3bc677c62ce7484be96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6c1fcc307e7c4d8cf2f5cd0daf1496a05a16cce15c1f3bc677c62ce7484be96"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0d804ae24eb3b4f41ff888c14ba0de0a4fd7aa0554b7c22563560faa928c92b"
    sha256 cellar: :any_skip_relocation, ventura:       "d0d804ae24eb3b4f41ff888c14ba0de0a4fd7aa0554b7c22563560faa928c92b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ab16d2596df2de306292b0aee8b623542ba97a3ef5a6b8b2d8ca64e68708f37"
  end

  depends_on "go" => :build

  conflicts_with "tenv", "tofuenv", because: "both install tofu binary"

  def install
    ldflags = "-s -w -X github.com/opentofu/opentofu/version.dev=no"
    system "go", "build", *std_go_args(output: bin/"tofu", ldflags:), "./cmd/tofu"
  end

  test do
    minimal = testpath/"minimal.tf"
    minimal.write <<~HCL
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
