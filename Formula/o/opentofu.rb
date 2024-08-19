class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "849f20c1f700910842c42fbf76730fabd4df82b0d0879d4bd9a88abe3d275b2a"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c156643b67fc852ef39ed3de5094519d6b2815aee9a3dd060efbaec055e38afd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "391372e854e5c1783d3723b32ef9763c220a8da2c7c9992e3d2a0573de755c7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b634f1f64c75e187e9b3d1024f98642d1f1a6d4395fde5e3db55496ff821d157"
    sha256 cellar: :any_skip_relocation, sonoma:         "a913020b7f7d41a8fc658e81bd371ed74e2b4f08f57766777f1df9f2c3420a9f"
    sha256 cellar: :any_skip_relocation, ventura:        "01e490b0740dc867a1f6349ee80f836a0ced7a093a8de54fbcac4adc3775f38a"
    sha256 cellar: :any_skip_relocation, monterey:       "2b6fdd3026489b8920ecc87b273c25da671ff143314585245042f74b89db8c1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7746031903fca201f5fbb3a1704a56fd15b538fc9808183654ff1f3605ec9f87"
  end

  depends_on "go" => :build

  conflicts_with "tenv", "tofuenv", because: "both install tofu binary"

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

    system bin/"tofu", "init"
    system bin/"tofu", "graph"
  end
end
