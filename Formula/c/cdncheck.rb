class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.2.35.tar.gz"
  sha256 "ac6e112ce65a0c346df24018617c7517cd10a0188655bd6a66fd5a61ab9f41fc"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0912b0101505adac50d5338599e7abaee413b9eb9b8d2be9dc653e06bbb71a79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8f7b2af49296e205fefe29184338a22289814bc5844ebe6d0191a5602f49dc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e95973e92eb0488a71963da8ecbce4f0d5c1beb90a32d348eb711d7b5aab512d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c27331792ad1e930b17f233cdb4dc4324aec843e7c04cdacb809db6dea72ba2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "118db2fd61865a69545a1326ee63676c5f670dfacfcd8cbd4852bc14f4d21ea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "daa8cbcd4fc320bc7f8e20a9d16ad887f92fe73d9990a67bd6a67ad0a8acf223"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "cdncheck", shell_output("#{bin}/cdncheck -i 1.1.1.1 2>&1")
  end
end
