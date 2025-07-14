class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-6.14.tar.xz"
  sha256 "9a4392ab12e56e75440b0b88dfe6db1f96bd7b7050305e8cf135848d8af99c21"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3926d000e75be945d42a3271fe79216ba8b501176e76d43ef638f7ee6301948f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3926d000e75be945d42a3271fe79216ba8b501176e76d43ef638f7ee6301948f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3926d000e75be945d42a3271fe79216ba8b501176e76d43ef638f7ee6301948f"
    sha256 cellar: :any_skip_relocation, sonoma:        "640a6fca8ee3b63d7105875698be1db96a508a0bb42132d2500d6444a86c4c1c"
    sha256 cellar: :any_skip_relocation, ventura:       "640a6fca8ee3b63d7105875698be1db96a508a0bb42132d2500d6444a86c4c1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a11b74dddbbbc6b584ddd010d797f98c2211d2d58bec0a9849315a7fac37d22b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6816ac83ffb33490b752ac21984e8b18009b486609f7f48982f2fbcd88df504"
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
