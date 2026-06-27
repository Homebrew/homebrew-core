class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-7.2.tar.xz"
  sha256 "806230f72ac4dc3cb584de76763428218d4005c2184c391f701048182ee9e982"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddbba3d5f6ff8af3575406b0d79015af54bc2c9b10e21ce3f331629122958a8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddbba3d5f6ff8af3575406b0d79015af54bc2c9b10e21ce3f331629122958a8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddbba3d5f6ff8af3575406b0d79015af54bc2c9b10e21ce3f331629122958a8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "abd1873b2a1dea7d6e9ab72155e20331702fa3baa7c456ebfb4955dd0a8cd8d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f7a5b02828a444f20ae7b7c658549485d43acde96b8dcaed3033f8c193231d5"
    sha256 cellar: :any,                 x86_64_linux:  "cf8304b5d61f549b13a53d70686dc9c4310703e09b199ac3d29e670818cb54c1"
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
