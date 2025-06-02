class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "8fc573e33db7336d307aa671ccea407bd6c3d092a84d22b65f4c1e9968502972"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10e8e16af41570eaa36c2b1258308ba3dccda2ccaaa88be5f6f59849730ef1f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10e8e16af41570eaa36c2b1258308ba3dccda2ccaaa88be5f6f59849730ef1f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10e8e16af41570eaa36c2b1258308ba3dccda2ccaaa88be5f6f59849730ef1f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b49cbe48ccf38ce2c7153649686db9ea0cc9b3f7d1d6da65dcbbfec9f65b641"
    sha256 cellar: :any_skip_relocation, ventura:       "8b49cbe48ccf38ce2c7153649686db9ea0cc9b3f7d1d6da65dcbbfec9f65b641"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "185f53c8518d3613ed1b5e7378c35a694839707a603d43a4a9b6bdde4ed84191"
  end

  depends_on "go" => :build

  conflicts_with "tenv", "tofuenv", because: "both install tofu binary"

  def install
    ldflags = "-s -w -X github.com/opentofu/opentofu/version.dev=no"
    system "go", "build", *std_go_args(output: bin/"tofu", ldflags:), "./cmd/tofu"
  end

  test do
    minimal = testpath/"minimal.tf"
    minimal.write <<~HCL
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
