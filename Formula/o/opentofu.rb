class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.13.9.tar.gz"
  sha256 "acb73b84a4f32150f8a097841fe2c48a2e13d35656ddab4851f46a4d681cdde4"
  license "MPL-2.0"
  compatibility_version 1
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f2f0d32bb2daeb5c077827b10b804ce4ba1cf473a76027babad82b820808a985"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "105c7890a9daea9ba1dd4e2f031afb49a1f73eacf1deaf58e10b9498f5a0258e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "207603cfbf22291af160a794d217abe6d13ef6d36642e2ba8d02a10be0563b58"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0ed63836df85edd6f55eac157e759bef61122c5a760495532c568116ebab2738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0170fb78939f395c0d898fd1e6fe1a74ac709b25e78c83c94fa615feccfb94b5"
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
