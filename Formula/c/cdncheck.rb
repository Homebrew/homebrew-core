class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.11.tar.gz"
  sha256 "f05798896d3325e066ee9ba36db0f02760cc9342e88af4a134db8164f4b02f3c"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a42791c620a665b33dea5f40b3f7bd1dfbeca7cca07e0e7e3cceddb8f3314db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb32e2b4818adb7ca8976bb81dccc74a41f67ced8995a3c8495f4595a934d31e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fc9a95c1ab25cd4e4523ee55e0ceb58a8b685ed93598a710bef6522e16e9447"
    sha256 cellar: :any_skip_relocation, sonoma:        "42b293a057da2da2682a7771c884c7d787b45965b27357e18ee11cff48aab37f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2834221b611c7c54939d134ccc7d46c093c4f57e8d41cead311458657921d280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d94a3b59478efdcd07eabec6f82974545fd6de8140fe3ee6b59c75d66ed1c34"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end
