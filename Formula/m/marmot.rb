class Marmot < Formula
  desc "Open-source data catalog exposing metadata to AI agents"
  homepage "https://marmotdata.io"
  url "https://github.com/marmotdata/marmot/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "2159f8ee0b1bdd8bfa6010b2044a0f38caca340789bb7713494e6cbb619831e9"
  license "MIT"
  head "https://github.com/marmotdata/marmot.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "988ac60ea8068eeca7e8810aa977d45b9a943b6c69bd056103b2bbd09843fbec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "988ac60ea8068eeca7e8810aa977d45b9a943b6c69bd056103b2bbd09843fbec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "988ac60ea8068eeca7e8810aa977d45b9a943b6c69bd056103b2bbd09843fbec"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "29d96cbc125f344a09b6f95b059b3ce2bd611c15fdf4f808be9eefa43adb2967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "9e9ed30eca2760cd3b7d8b4da4368464fa6eed5e8f92912a0505b614d094d3c2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[-X github.com/marmotdata/marmot/internal/cmd.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/marmot version")
    assert_match "MARMOT_SERVER_ENCRYPTION_KEY", shell_output("#{bin}/marmot generate-encryption-key")
  end
end
