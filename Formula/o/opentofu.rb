class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.13.10.tar.gz"
  sha256 "2442f6bf9c18810cf3923dcbf7070a0023d2af8203661c24d857f0d156837dd9"
  license "MPL-2.0"
  compatibility_version 1
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    manifest_sha256 "55fd0b2dc9e00c19e2682f05564e9c78a4426cad548d4a03c910990d24095a9d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a4726c9314d4f06093a0e35f3cc7d87d5eb3534eb0fae5eb46ce827154dde4ef"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3920e86b1e07987d457b4d3961cadf712123d0b9a0bcdd88a848d52399162c43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0f0647b00f28a4b6cec2eea3447dec7ed3a4d0cd99f1ef41b4cc00c407b4dfd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "00c94834851a30b8134f2dabf0bdf0750d2847405011276b0a27b39aab66d132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "56f68d65a3c4239096e5f2a49a1bff2647045949030b8376aa5d87ba24b3911f"
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
