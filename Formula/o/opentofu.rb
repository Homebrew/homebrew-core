class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.13.3.tar.gz"
  sha256 "3ab67d0545f60d0ce39d47d643a3a57fecadc945cc632e8c83a6b40f3238a4b7"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0eaea68d29476e6596ebee4dff0c58c4cdc4614568b3ed7ad54147fc7842325d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d57f970a5b7cdbf6a0b20e522f899379072ec91c2bcce388b116dec24fbeb87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0e94fbaa3c0f75b2a8dc1b9a36c83cad522e0014eb347d3d5cf21660abf17ced"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1320f9e5029df96b206ef0e38fc3fdec6762e639e96c56fa5d8c1f0afd8c0cae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fe875126e511de1d1c8f333b978e05736656fcacf2cd4702f47d1a3eea9f648d"
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
