class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.13.3.tar.gz"
  sha256 "3ab67d0545f60d0ce39d47d643a3a57fecadc945cc632e8c83a6b40f3238a4b7"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a3883f5bd3a37e6c35c45fa01ccc203511b9e4908ec0af87d87cb562f94e0a55"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3a7d7989e2b7710143146a7905a6b625e870a996c62b7dfe2517d438cb2069c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1ad62fa92c5d1f501400b95f7d66c148cfb5dfd945d6e5cd80e093d94bc71803"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6aef7891c9ff9e01ef7c4a4baeeb1e179c8e02af1eec07218307e69877d95ac0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1d35a26368795aed3d40c67a124336d6fc463bc47e88c759860f264483eb081a"
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
