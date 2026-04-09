class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-6.23.tar.xz"
  sha256 "a84880e138db0e7497bd0ee62806a8c5299566dada5c725e65e86afd7fe71fa6"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aaeb3b22fc665ce65f2edc0da2a4762c28c1da1421771842065cdb52c94a8bf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaeb3b22fc665ce65f2edc0da2a4762c28c1da1421771842065cdb52c94a8bf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aaeb3b22fc665ce65f2edc0da2a4762c28c1da1421771842065cdb52c94a8bf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "48c038d55a72beae26dc5870406315b5bf64ee66ce8257d2288461d57b350582"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0e75bd67f9e1d691e76a902f071f9f10a238d0c475c15266a39b163f5a04cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d777300bb20bc5b0222ae451418340976aed8c0bb41ad6cbfd601e77450d2a85"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"

    generate_completions_from_executable(bin/"incus", shell_parameter_format: :cobra)
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end
