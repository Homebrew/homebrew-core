class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/refs/tags/v2.11.10.tar.gz"
  sha256 "886e89be8a43c9ce769f38b6929e137fe1d1b9008f5d62fb6e2af0084713d97b"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "main"

  bottle do
    manifest_sha256 "646ef92646258a7035f287f92111b0320f0b90af425635b738a9140a5332aae8"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "76fa88797c42b640a4d401ddc905e3db4710c6546c1514a2dfefaba4cd9783f1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "76fa88797c42b640a4d401ddc905e3db4710c6546c1514a2dfefaba4cd9783f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "76fa88797c42b640a4d401ddc905e3db4710c6546c1514a2dfefaba4cd9783f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fb31ce4075c5a55c3dd2023f9de4eabb75f24f01624360cec3a2b478383a0864"
    sha256 cellar: :any,                 x86_64_linux:      "5703747176b5f8555dde422a351601866f1f4846d6fe3bd0cbc9fd90d102c012"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/muffet --version")

    expected = "failed to fetch root page: lookup does.not.exist"
    assert_match expected, shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1)
  end
end
