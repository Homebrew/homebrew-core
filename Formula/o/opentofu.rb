class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "04f43bc496adc3dfe5ca39121355ed5c12b5b1f3b2cceedf1aae3382bceecefc"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "508b01d909ef6ff490ea4c61e168855ffd1813a288406fc1a7148b9554908c38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08445a4864b3a0a4a4f01fefef8959a864ee6359d3f10753d3e56882cdd27883"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e541ac96cd68979c8a2953338cdb9499b24924f330af8854c004f112fd3547f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b095806c5c78d1047187ba66c2ff4e1e96dc14629d4a594977588a76272d777e"
    sha256 cellar: :any_skip_relocation, ventura:        "d131b28b84d7d6a96f8904675ee500ac7ce75bbec280b9a39782fe0642a1058f"
    sha256 cellar: :any_skip_relocation, monterey:       "ebfac9b6d16f9e3e987ddf07f3d4f47f3a81f24662954a933edc5a4b2aa2a0bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b28feb55a41bcb9fb6ece68d079611222804adc2a930af0e388bdb85970888a"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install tofu binary"

  # Needs libraries at runtime:
  # /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.29' not found (required by node)
  fails_with gcc: "5"

  def install
    ldflags = "-s -w -X github.com/opentofu/opentofu/version.dev=no"
    system "go", "build", *std_go_args(output: bin/"tofu", ldflags:), "./cmd/tofu"
  end

  test do
    minimal = testpath/"minimal.tf"
    minimal.write <<~EOS
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
    EOS
    system "#{bin}/tofu", "init"
    system "#{bin}/tofu", "graph"
  end
end
