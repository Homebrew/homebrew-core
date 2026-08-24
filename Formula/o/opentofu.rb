class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.12.6.tar.gz"
  sha256 "d6b49908a66ad277d7de33e9a218ae11b956cd094e39c82300b9b75cac2479ba"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef005cac5765e8ca0a3935ced7cdc22a10acc1b2d71e4b9e384900c507607428"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c1f629a74b053fcd4b5f93503e1232e08912323b8853c8c2c6202dafe0fe02d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17185f281019ba6dfd26a8978758aaea0fd508a29ce92af79d59fa8499b99cbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e2d8cb3e2bc1aa0f4229b391bef967933a866d536952948bbd9864131b7bfce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f38acebf07da4844e33b8065e57379c5412e5f2c83fb74a9cc359dd4221b5de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c217fa12380b0aaf4836ec0dd9d53cb124755aa4d7975073a84b5cec85caac24"
  end

  depends_on "go" => :build

  conflicts_with "tenv", "tofuenv", because: "both install tofu binary"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-X github.com/opentofu/opentofu/version.dev=no"
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
