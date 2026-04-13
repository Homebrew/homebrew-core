class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.11.6.tar.gz"
  sha256 "4c16aaac1c8db7386488abb13226f93fed4141698d0ebc02711029e6d6676a82"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70c9e4746998493780c9d3b10710a9ef42b137629001b8b51d72c7ef1b6cc603"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ab4e24f028a7a24f63ceaa5bb519b39f8a6aaff8386684813701e800676aafd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20bfa520654cf9dca000a0d0ab06d598d35861e0dc398a86101ec95767d6baba"
    sha256 cellar: :any_skip_relocation, sonoma:        "08e90f73efd5ca4d484db2fbdfec3d7a09b5e579c3ad274f048125ec515bbc7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61852f719b89aff5bf0580415592e609da9997c7d9ea4cac71d28c776ee6247a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f68f61b1b286190ae898c100bbda1e08c7f4a41db03bcf369bb3236a8f96af67"
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
