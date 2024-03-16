class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "3bf0fc807004ba26305331ecf1334ff2160f8c131ee53c107292d60069400da6"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "883170dcdc5df4bf8d895dbabc8c6b06941c4c819266ba58bd3664674f1022ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "564ce4b3c92a68e84ab2ea7cf6fa73c093e4a6b0f012ece99373996d7491691c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae7b28ae61d35203ba1a39868c9b5c1a2cbd656cb55c2b2887d57f68a05436af"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a4ccbceb83e60fcb7474478a877fcb282b41050bfe7b872ba72ab1ff456f84b"
    sha256 cellar: :any_skip_relocation, ventura:        "97d3590c34489e3516bc77988582c003e1de067ff18ae0d1b52cce7a9e78b093"
    sha256 cellar: :any_skip_relocation, monterey:       "557d894c0e9451d07110425595d49d7f671f393d2437a035f24e5c5f8edae5ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a6fe96e4a92938356ce567dcf4fb7cddbae5b82f5098eb169f495d17aa1275c"
  end

  depends_on "go" => :build

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
