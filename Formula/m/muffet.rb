class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/refs/tags/v2.11.9.tar.gz"
  sha256 "528852785fb2a01c78b0688cfdac726b0140900f6bb1e59541a5e80fe203e779"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "72d81b0af27b3f6f05d18cc1f95c427457b9c7005a16468b12e15ffcb1028b4d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "72d81b0af27b3f6f05d18cc1f95c427457b9c7005a16468b12e15ffcb1028b4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "72d81b0af27b3f6f05d18cc1f95c427457b9c7005a16468b12e15ffcb1028b4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0e85f30d3020968682ce2a208f9f10186658c35de16ddc683259442337a3611b"
    sha256 cellar: :any,                 x86_64_linux:      "f5595244376764b552d8c1f4099b893495d8b403a2d3ec1b8f8088d6d48a51f5"
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
