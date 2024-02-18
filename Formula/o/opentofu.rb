class Opentofu < Formula
  desc "Drop-in replacement for Terraform. Infrastructure as Code Tool"
  homepage "https://opentofu.org/"
  url "https://github.com/opentofu/opentofu/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "7c355deadd8abbf5671efee2217a97243ec1059884db4c87f66841612c0a5263"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b9a9260dfdd27239810829a123428167bb93dbb175c198c5bf4395b7e93070b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b84f74d6ef7017da978ccbbdd27d5688780d1b595d1f99490c60bc339b0f22cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fa48a5e0b14472f1daf9861ef7be0d4fa9b41191cc18433535d0c25728b2a23"
    sha256 cellar: :any_skip_relocation, sonoma:         "daa47b60f65cefbb31138441b1d9e7b383493905ac96cbad44f69ae0b77513f2"
    sha256 cellar: :any_skip_relocation, ventura:        "6d162962500359ee08c10ea33e822f758bda14a03c280347a56cd44c6f8e341f"
    sha256 cellar: :any_skip_relocation, monterey:       "6b558199e224684e72ea923cb66a843f9a554da6c7e0b4fc09aeeecacb0ca396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b81eaf245d31ba914f78dd263fca374f8d7722cb18cf4d09a7a69bb82247db0"
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
