class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "36295ac570bb4d9f72c2488a75a3e8e0509bd112430e766818081c1df2cb65ec"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89a64c811f9ee32d0495132643ede9b31123378571ca3ddd90ba497d0adc25cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89a64c811f9ee32d0495132643ede9b31123378571ca3ddd90ba497d0adc25cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89a64c811f9ee32d0495132643ede9b31123378571ca3ddd90ba497d0adc25cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "edce89dfdd0aece61c8b791e6df15f36048a4bbbc63844ce5e18401d4f06fc77"
    sha256 cellar: :any_skip_relocation, ventura:       "edce89dfdd0aece61c8b791e6df15f36048a4bbbc63844ce5e18401d4f06fc77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05c3ff5180dac3e5dd29732baa35eec909245b7d2fe45fbcd67be2a5411d8086"
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
