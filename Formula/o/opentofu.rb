class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.10.6.tar.gz"
  sha256 "c6712629ef05f461d72c158de32bd009c29844a21bbcfa7bd7f582a341267f29"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d35a1c80527e9ff4f13b8a6eae2be4b014ff6741390b9491dcabbae83ecdbc42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9023d6b52ab74a60d5141f6c5349433a58afeb85327acdc1923e887fd57060fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9023d6b52ab74a60d5141f6c5349433a58afeb85327acdc1923e887fd57060fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9023d6b52ab74a60d5141f6c5349433a58afeb85327acdc1923e887fd57060fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "0673618e932cf96b7468f84f12c80b9408d5f7dbce9771f27788a722bc5590fa"
    sha256 cellar: :any_skip_relocation, ventura:       "0673618e932cf96b7468f84f12c80b9408d5f7dbce9771f27788a722bc5590fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57d9e1640de2438295857b712ba947afeb3099cbce272c0c450432c78e343922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dc4025a3e579b2340176b7dc624a40537c9bf5ff7a4801839838644fb5168fd"
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
