class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.11.5.tar.gz"
  sha256 "450f962f262d9f484ad1fb73454650740cdce0d83a854ad8b6c183cc5822eb09"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a156a503029c70691decb8a0f9ff36eef23be324af98004d64497e132d31cb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d3f4048993cb38563d203a5659cd89261529419b0de29c59379aa1062c49675"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88334c8fa4c9e9350037be4cb2933a1eb63a635a191651e1525d4a7c66a3ea14"
    sha256 cellar: :any_skip_relocation, sonoma:        "80241dc55015d424562f945655215868b185b17fe4e7f20b956a7b83ae878fa4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e23c2fdba1b90e3ca25cf2d4de7bacc3b65b6db431e09aa5c649fcfa3cccd51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4628d141c87a864476319106ef800ae0ef5b2ebcd7a745edb3d286f832a080d6"
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
