class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.13.5.tar.gz"
  sha256 "14475a9be680579788273bc004a246e7b8b58aee2a83921687e0c2657033d38c"
  license "MPL-2.0"
  compatibility_version 1
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "810ba3a4eca1d09d13da3f295c95ce06189e407e7e896b12789a94e11d8e965d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ec9d5cc967abd8688ab52e8c02d111719e8cedf98d34c85ae1636c8e619fb770"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a0058b2a3341b1935e560356757321efef366e2ad2513d6817d946dc7513daaf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "73ffeff98bb1ed0f513fed3f4816f834c511f60bbfe860da82d2c855dc5809dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b2aa1b6ae861fc93e8ca38fc0a91a9297ddcd721c346d535ad6cd797ec361dc8"
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
