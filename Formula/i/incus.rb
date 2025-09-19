class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-6.16.tar.xz"
  sha256 "ddbf3abf81c4a77cddeb0902d5e0e0471b83498d73db1a912e68f4ea71aa0850"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b784dadae00f7532bcbcf391541ad65483d5b1e78ef9b269c64f2bd1247833a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "632d4f09c889d90d2d10c8f1f3b2b5bce76c873fbd53ae422e89d9c157fd496d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "632d4f09c889d90d2d10c8f1f3b2b5bce76c873fbd53ae422e89d9c157fd496d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "632d4f09c889d90d2d10c8f1f3b2b5bce76c873fbd53ae422e89d9c157fd496d"
    sha256 cellar: :any_skip_relocation, sonoma:        "71bc3c73287215c76d634eb9a4e6cd4c05ef4911a68b28eecc044dcb4f156e7b"
    sha256 cellar: :any_skip_relocation, ventura:       "71bc3c73287215c76d634eb9a4e6cd4c05ef4911a68b28eecc044dcb4f156e7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c1e21217d4058a65ec2c7e24ed4c7a74c1db3fe8ee16503df23b4cc7530964c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "230777734f9e40ba7e7806f4c53c89a7b934a229e12ea1022728c8e529d2e189"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"

    generate_completions_from_executable(bin/"incus", "completion")
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end
