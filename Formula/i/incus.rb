class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-7.1.tar.xz"
  sha256 "c684c7e9447df1e2b66cdd37c8cc602c4e995459a6c7e848b5ef0526ac7aeb6c"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f10373bdc8d7bc8a76082218f44d9ebc0ec4379a61d21353d029b88e02ab9ff9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f10373bdc8d7bc8a76082218f44d9ebc0ec4379a61d21353d029b88e02ab9ff9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f10373bdc8d7bc8a76082218f44d9ebc0ec4379a61d21353d029b88e02ab9ff9"
    sha256 cellar: :any_skip_relocation, sonoma:        "158c02bd0c3f24b46ff33549a679dfda069199fc9b0b25fe1c68cddd0746daac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b64eb71170e51e1b18140d04991575b724102cdfa6e653e322a02e95525678f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "305a15634d1f806251ebefad559dba082cd6cac9e88f67a994f7f575c1064b72"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"

    generate_completions_from_executable(bin/"incus", shell_parameter_format: :cobra)
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addrs"][0]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end
