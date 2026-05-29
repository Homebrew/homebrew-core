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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94313fbc004abbf08eda3e1bc658e1b75000309ca45b9bf1ae297f718c983709"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94313fbc004abbf08eda3e1bc658e1b75000309ca45b9bf1ae297f718c983709"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94313fbc004abbf08eda3e1bc658e1b75000309ca45b9bf1ae297f718c983709"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ae40b9ddc33ad080743fb22caafcc165a5b1d2fe8a1623ce6521cab7cbd6012"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75cfcedd37b5f050b7c745ec81046f2a328385d1d2f56720d58b2c0cf285ebd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63a6fe5f48cc97c730062e14e426d1d14313970256faca0f38ab6600d8260238"
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
