class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-6.22.tar.xz"
  sha256 "0ed7f1e720d2bdd243d16ec42ac14d02fef1cc63a2a23336deed8e57c0465514"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67260a6d2ace2bacb40ead592d93fc3ed86a1ed30808f3f40760e71c01df1f1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67260a6d2ace2bacb40ead592d93fc3ed86a1ed30808f3f40760e71c01df1f1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67260a6d2ace2bacb40ead592d93fc3ed86a1ed30808f3f40760e71c01df1f1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "921cbcfa7c75d7699c199b2dec498adfecc8cd0ff86e2b6377374cedf765319b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "832c7e18b74a4d7908d121fef1887e45e661d53cee5f310705de187f8077eb20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fb03f7ad9e279e6d81b3aec25013f8085111b25bfce411159e9896dfd9306ed"
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
