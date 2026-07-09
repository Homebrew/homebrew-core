class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "0691d6c4ab43bcfa708120a0c71ece4be43ece4327445a572d91649e4e09af0e"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd962ebb4c955cbf2b50b1a055be350a1e651ac99f5d6da7b51a93d96e62dcd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b20a4b787e9d4ca5c994d1dcd061ec66410a0397baaaec2bdd1c0fb4ca6556f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06c8f997aa6e8ae3f7dd566d19d02c64accb0a5b8491f0772545ed177a1d6262"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea0f86ee0714cfa3f4ae5bb0e22a91a1acd46aa71e6f3821fdf27cc69b18eb47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9b7f1f6cb862ba9480e61d3f40e8f3b034c4a1b83b82a62b622dcbc6262748f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fff5cc41990dc01830d472d8be52d469172704b81bca03d877645dafbac7cca1"
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
