class Dnspyre < Formula
  desc "CLI tool for a high QPS DNS benchmark"
  homepage "https://tantalor93.github.io/dnspyre/"
  url "https://github.com/Tantalor93/dnspyre/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "198bda936364a71c09749c625d19e67ba2125639dad54ebd81467fc071cc979a"
  license "MIT"
  head "https://github.com/Tantalor93/dnspyre.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7ab0bf15190946990982b665bd871c61a522478edc321f66933451895a71de7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf762fea6cff6876e5f7c0e76860498f66147c6120257e2523f9b83bb3096352"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02a5a04ac7f694d3a4e9bf596dff880f4764e7ab6978d3e623ec769a1c4d70d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "62fa9fda30f140b7885ea225b971ecf28156687a2cef2476bcf1e6d58149fe9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d8f9615714e8e64b0b906c3d7ea272f8c68cb34ab8ad05b4dbf9b97e6bfeadf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d58c6f706beb818f71e8a13a262ee654ff90221c8850a8aee565e42196fb923"
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
