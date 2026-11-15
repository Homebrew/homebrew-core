class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-7.6.tar.xz"
  sha256 "3b492ff0710d56d23b0dbfc7f5b5320efee9f6f6472b9275d6abd443c889a395"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "51dc23b3808c29a15c9f2cfe3aa37fb2a5048636e45022981884329b03724f9f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "51dc23b3808c29a15c9f2cfe3aa37fb2a5048636e45022981884329b03724f9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "51dc23b3808c29a15c9f2cfe3aa37fb2a5048636e45022981884329b03724f9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "74209d89911b148665453128ad8bd85b057e2943383cfda34d36ce033f52362b"
    sha256 cellar: :any,                 x86_64_linux:      "4ab6c53fd785c9cb254ca1959f216071d93346c07f1c0e5560941554f030b4f5"
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
