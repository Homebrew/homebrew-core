class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.13.6.tar.gz"
  sha256 "a3711c9d8b3742f0cb7c22a9fc9f1d93431a6a084ac36bdb25716d32cc0e8a86"
  license "MPL-2.0"
  compatibility_version 1
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "32551d210644c9ff47c3a7a6808253df89e3c301ffee15e480bd3501a6f7f0f6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "52014a2ed9b6635f0564a5fdcfd63ebb8fe4cd42d6842617b765ecf6b769c09d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e6ed5f690c8dfc33f6bf6a6db45548e0ac88c95f8df30bfcf29f223c36b23a2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4403fc103d7d5012c939208e4dc949b4a6d35c8ede75641e610696674262a189"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c17daacbb32a466a7b9c951ae03bf23378e04d0237bf0dc92039fd1a193aaadc"
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
