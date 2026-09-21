class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-7.4.tar.xz"
  sha256 "bca540edff53374d075a35c5f118c8675804cfc426e0b29acd70e9c9b6d1a2ed"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cf3f95482d880a99140fe2736cd4adfd14ec0eb2d6de1db13b9b189c76ddc5b1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e4b538221e2dede616e957f43fb6883c9a73ca2cd49bbf9298d76bf07991ed0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9e4b538221e2dede616e957f43fb6883c9a73ca2cd49bbf9298d76bf07991ed0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "9e4b538221e2dede616e957f43fb6883c9a73ca2cd49bbf9298d76bf07991ed0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4b0ff310f5aeffb9be242ff8d496ec239b2c4b71e4e3a14ca503f7e2268ed4bd"
    sha256 cellar: :any,                 x86_64_linux:      "ee8e0a964d9a8d8835267abed2fef16ea6691702dc5c00e4dc857131c3d311b1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/incus"

    generate_completions_from_executable(bin/"incus", shell_parameter_format: :cobra)
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addrs"][0]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end
