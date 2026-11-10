class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/refs/tags/v2.11.8.tar.gz"
  sha256 "85a398fabcad07950184f13222e289647e4ef87ace46138225453c6bf269940b"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "800b738b0bc907a1aa5a1bc9aedbb2be2a123c144caa3cfaf035cb5345b2d304"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "800b738b0bc907a1aa5a1bc9aedbb2be2a123c144caa3cfaf035cb5345b2d304"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "800b738b0bc907a1aa5a1bc9aedbb2be2a123c144caa3cfaf035cb5345b2d304"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5c2c2accd06974214d48e5607aee12a3cb2af0c5a129d4d079a253fbd5346f8b"
    sha256 cellar: :any,                 x86_64_linux:      "732241f0a91999f14b1e0d1c46e70fde060352039787ffdae90b2e975c533822"
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
