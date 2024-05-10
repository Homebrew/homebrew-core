class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "aa21e326414ab7251c29d769847705281a7f73002685b187c41073b5fc03f6be"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a52ad0d92cafa7ea6c4aff04757091eb0a36b9c667a35231873ab5aa405ee46"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8897c04f76a8ddaf59f417ceb4a7f431e5a35cbf1b9d81a0fa83bcd46bfdb4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48d459ac9a8e115c760135dc32900bd05f89512b9b5820d57cc87751e29bf00b"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ad23e9262b5ae6f04c95588d989b4127e08e3daeeed31d6c6441cd11206f2e4"
    sha256 cellar: :any_skip_relocation, ventura:        "5dc9869cccf6cc0ace216ef42fd9e8dbc2053281a002a0a0b266a24590d53a7c"
    sha256 cellar: :any_skip_relocation, monterey:       "98f568c903d303e7e0f4f364c3c7bdcacff97c7b5f0c240e88ca0c9c26d33650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "472dda53730a96cf8ab846a50a5f931d634ea1b491204bdd41db4ae27bdb81fa"
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
