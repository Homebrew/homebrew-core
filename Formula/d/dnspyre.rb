class Dnspyre < Formula
  desc "CLI tool for a high QPS DNS benchmark"
  homepage "https://tantalor93.github.io/dnspyre/"
  url "https://github.com/Tantalor93/dnspyre/archive/refs/tags/v3.10.2.tar.gz"
  sha256 "9e794e9b32e379efef673af23e5f8985037b1a39c839ffdfa0e70960b71cc160"
  license "MIT"
  head "https://github.com/Tantalor93/dnspyre.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1251ad74a454ec67f49d35d5e8c15e87fcf251ffde88fe0f98c0080dee0ecb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e202f047c5229f5e1c40f971ac81c78623102689cb85b98bb8aafc3208be492d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5b4f8fd5d25b2ba65b44a9ec5938d50e720ba187febc222514e67701edd59c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fd3a24742cbf1c7f0ae68780f1df3ec274110d92f99adf8e8031f3fb2fa5e5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7274ba1f4135285a7b02cad40a530733160599f1b3f46a6164a0a6f3b31a6cfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "555af82b5cb6787fba1a8914a1c4c94c98454b8badf2fc99da70b670d39af114"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tantalor93/dnspyre/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dnspyre --version 2>&1")

    output = shell_output("#{bin}/dnspyre example.com")
    assert_match "Using 1 hostnames", output.gsub(/\e\[[0-9;]*m/, "")
  end
end
