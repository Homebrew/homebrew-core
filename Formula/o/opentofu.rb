class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://github.com/opentofu/opentofu"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.6.0-alpha2.tar.gz"
  sha256 "929105faff706c780acb89c2bbaa040a6110f9acba21e8b69751c848d64b521d"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc75e7cfa974362a4972f6f80d728545b9a58c1f12696317a906e2ff16672e63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "817a58487c2ee6958a767cf9f25445fe0013174d7646bc9774bb2d36d5d853a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "090061c2904d2b932f1d60a02284c4f4a6055fee66982dbe1e956549c5b0a647"
    sha256 cellar: :any_skip_relocation, sonoma:         "1e1e4986fa9f0b0359d6b0154119f48a98ebd8bed2a85b9b2206984c83c94cf4"
    sha256 cellar: :any_skip_relocation, ventura:        "a18cdb50c6f501eeaa6e79723a6474bb5c295a905f3c2ec2aeb0b3f002b36e0f"
    sha256 cellar: :any_skip_relocation, monterey:       "08fe8e4fc36e096e38d54cb4503b36791477c1195092b67fafdae4e95d44785b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77e5088a2e80ead29d1b62e8c7aef48ded122379f01e095a5c1252ff67657d09"
  end

  depends_on "go" => :build

  # Needs libraries at runtime:
  # /usr/lib/x86_64-linux-gnu/libstdc++.so.6: version `GLIBCXX_3.4.29' not found (required by node)
  fails_with gcc: "5"

  def install
    system "go", "build", *std_go_args(output: bin/"tofu", ldflags: "-s -w"), "./cmd/tofu"
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
