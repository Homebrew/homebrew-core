class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.12.5.tar.gz"
  sha256 "55988a6f5401487d3f475df282f77f4d2ed69371a44f2f81943044b3ecf1a3d0"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68aa9655d8b3414b64e36bfb49b969b77c2ab9dd5f085b94ce140fc983a15be2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c12b62593c72717063bc6802561f49c6f53ae7fd823fd4baf9cc5bc2fa043372"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d693631f98784f083d07b1d63750c21009ec973fe2b294ee0c6afb18ee20a51"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc61a41ad43d960b35a462f6f908d53ff99fd2daa8737e1619496adb175a67f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91e319f7f8edcc85a434f4884032afdfcb8493bcf3735810ad1f7be739681914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8717bda2e2d2c5c3d37c13fac64de2e49f512fc13cd953b30ce81bf28285b80c"
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
