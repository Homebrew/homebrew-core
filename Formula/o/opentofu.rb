class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "179216c485c6df55e9f4576c622fd12f3784ef9e0720925c2dc4a155c6b4aca1"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98de5b0268719cf13e1de8fcf144fc1abc35fe1472339f26ac3889f903fc0bd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8e85b35493c6da39a4da223a622131055ec1997288993e50824f5416968e169"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fff8433a446dd6b2198c49a614d1a90b776f43f8729ca91fcc77658e1a30fe53"
    sha256 cellar: :any_skip_relocation, sonoma:         "3dae26b4cef2f5a4acd6bd39bd4a7b6bfdf73e65ab795fedbcfcf82a027330e1"
    sha256 cellar: :any_skip_relocation, ventura:        "45ab4848d4b6bc1111602200fee45b2836bdf93e2b8e84dac5cf798ff43e7128"
    sha256 cellar: :any_skip_relocation, monterey:       "16e44d16afbad71a70e7af90af878f18dccf9bfecb05050c2949472ba11fc7f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50f539c168709f90a2b9d31683091cd121bb96ae54726b31eaf9670d20eda8f7"
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
