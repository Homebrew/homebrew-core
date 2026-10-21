class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "54c534f3d1df253430cc02220d94b91c1d563e95f040bc24d29a4c45bc197838"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a654c527969c7c7791a254e2c5b5bb4cbaedd223c68ea8d457f1d67ea4725bae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5dbd9d25f15fda00bcb9b80ef5f7c9c4fc65c8a0df1c4bdc73bcf105a3e7afbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7d54ee72ffc5a66c08d7ed7ce743f4123461c1d4702f52ee9c1f5fa449e24d0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b691984c900749802bfa59366d088e72ae89511613a99f361ea59f3f329361c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b205e7e7b4ab9f0439f9842cf9f255840e133fe5d874c88534bf18d055ef38ea"
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
