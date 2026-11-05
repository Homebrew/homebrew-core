class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.13.9.tar.gz"
  sha256 "acb73b84a4f32150f8a097841fe2c48a2e13d35656ddab4851f46a4d681cdde4"
  license "MPL-2.0"
  compatibility_version 1
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "47efe23731bcdedb68dbe2afa3c54c1d2b2088eef8e76b9957071275cf8ffb96"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "db582ca72b47da722c5959c2eb9f656a91ffeffe9b5d451be8c7fe561ba1ddc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fa998eacec2bba8dd200d6ac4916914dd1cd5ec68ce24b9f8235b43acd9c6b11"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "977380eedb5060bee3b6209cd7f74f561b7c3c3d8bdae1f00915d94d46728791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5cd71ffab13f0566f55f7bccf43fa7041e4d90e31065937045597ce29d945be1"
  end

  depends_on "go" => :build

  conflicts_with "tenv", "tofuenv", because: "both install tofu binary"

  # `test do` block downloads a provider from the OpenTofu registry
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-X github.com/opentofu/opentofu/version.dev=no"
    system "go", "build", *std_go_args(output: bin/"tofu", ldflags:), "./cmd/tofu"

    generate_completions_from_executable(bin/"tofu", "completion")
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
