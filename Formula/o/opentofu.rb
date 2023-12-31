class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.6.0-rc1.tar.gz"
  sha256 "39a0d341ac64c129b6d0d6a9d1707f78d3252606cdee036826e592b95b663f3d"
  license "MPL-2.0"
  head "https://github.com/opentofu/opentofu.git", branch: "main"

  # This uses a loose regex, so it will match unstable versions for now. Once a
  # stable version becomes available, we should update or remove this to ensure
  # we only match stable versions going forward.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+.*)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "591c1c2404914662080a562884d073b7841651524896edcd62d30bc0c82f06bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "597b6eeecd1a97a859c2b410820f30ea8d8e2ce9c322bdf1ee3908339bc61a69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dba6037893c721cda03900a935d4eec5bac497e155235b63ff32811543635c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8f49aa192c8503d55369677901665643bde9e8b74fbb859ad1e881475a1bd80"
    sha256 cellar: :any_skip_relocation, ventura:        "b8eb42f6b730789d3286c89c4185e503af56479aba11ba1de632241fab2a8b78"
    sha256 cellar: :any_skip_relocation, monterey:       "3112e19f86cb112347115ebeaa5e9cfa8599dc3334787f91089f8836f976a0ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60ac227240b201914e69c25001791b1c4f7ca520c5050eafe3c294e0b4c2b26b"
  end

  depends_on "go" => :build

  # Needs libraries at runtime:
  # /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.29' not found (required by node)
  fails_with gcc: "5"

  def install
    ldflags = "-s -w -X github.com/opentofu/opentofu/version.dev=no"
    system "go", "build", *std_go_args(output: bin/"tofu", ldflags: ldflags), "./cmd/tofu"
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
