class GhOst < Formula
  desc "Triggerless online schema migration solution for MySQL"
  homepage "https://github.com/github/gh-ost"
  url "https://github.com/github/gh-ost/archive/refs/tags/v1.1.10.tar.gz"
  sha256 "70222d979e6d442befbbc11cdb16d420bc84ae7be277d79648c420e4458251c4"
  license "MIT"
  head "https://github.com/github/gh-ost.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "088bbdff67ea6ca883a89dfee690cd9f3eb9a53ceab47497c514d6f3d4ceeccc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4398593cdf31cacc2e8428c80123efd955872d9d58c59700d127ba5d5ce601e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23273fb6afb4ccfa6cbd7e33f3761c7fbb6cdabb07291b7d0ed45cd2c2679949"
    sha256 cellar: :any_skip_relocation, sonoma:        "770cce63021f23bbc4d49a1b2427858bb7bd40da01e00f8481ce8548bb06d81f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb363c67f07d6a8acc41348636d7bb77b2af7de6d14a0b0d8bebfd4f58596014"
    sha256 cellar: :any,                 x86_64_linux:  "fb1f6c26267d2bad1165eeb0cd314f1c56f7a39f6c82cc25da5d84e25e7595f8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.AppVersion=#{version} -X main.GitCommit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./go/cmd/gh-ost"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gh-ost -version")

    error_output = shell_output("#{bin}/gh-ost --database invalid " \
                                "--table invalid --execute --alter 'ADD COLUMN c INT' 2>&1", 1)
    assert_match "connect: connection refused", error_output
  end
end
