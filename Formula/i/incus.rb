class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-7.7.tar.xz"
  sha256 "e15430899f970472f7abfdf8151edf86d30558df2b39cf1e65aa53b9eb5a7a48"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "c9a523bbbd0d82aff888b25312769b8f7ccde80737cb1ee0888aa248f3f91f65"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "db8bbe9d154b052236d3187cb8693b4b23dd52083a5fe002c9cfce70494b6049"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "db8bbe9d154b052236d3187cb8693b4b23dd52083a5fe002c9cfce70494b6049"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db8bbe9d154b052236d3187cb8693b4b23dd52083a5fe002c9cfce70494b6049"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2cae8a515c526215673e8f5c076fcabb79ca39784135cc26b7481d0f2491e461"
    sha256 cellar: :any,                 x86_64_linux:      "99fb4e5678dc34f77b63ec7ed06ed3111e5435090dfd4aad2d324a89f9957f37"
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
