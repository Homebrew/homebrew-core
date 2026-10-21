class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/refs/tags/v2.11.6.tar.gz"
  sha256 "2f54696305c38dc4892a18f7a454e2d6f9dd30fe7060266f44e96a797d208eb9"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e14aa0b84c860d8fec1f110e7b47be927496922398afd3a31c4a8689d46f3927"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e14aa0b84c860d8fec1f110e7b47be927496922398afd3a31c4a8689d46f3927"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e14aa0b84c860d8fec1f110e7b47be927496922398afd3a31c4a8689d46f3927"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e52efdb685c908069ec489477d0bfe23dcc194213755ed059918f76dbc9aae19"
    sha256 cellar: :any,                 x86_64_linux:      "2dbf955c4ae6e55b15754a2a975629ecfa68c9f30255ce966d382a8535f6ded6"
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
