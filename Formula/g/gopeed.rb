class Gopeed < Formula
  desc "Modern download manager that supports all platform"
  homepage "https://gopeed.com"
  url "https://github.com/GopeedLab/gopeed/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "2309e15c2f83ab8bd67a9f268fc36feec633aec1bad7ecf2888be26d7f233b7b"
  license "GPL-3.0-or-later"
  head "https://github.com/GopeedLab/gopeed.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb2603abe43db5588aabf5917f8644f72e5e28970b3de6db3962ed43e776c69e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74c7c8dd529326775e8df35af9538d0ad9ba582bcd669ab3a4378f388e380785"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d9b8b8169c13168c6ee2bbca3c62a8e0ba8694b646d4215e449aee52eaf7fd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b5f7c025b7584a43655942abbee5760a95b637ba3685164bf6364f8f191851f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22772f0e15a20aec1cc2a24c269e0c11adea5cca2804db99db12592c3ecaf706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "debb1dfe749930277304410cc2e34610aa1526e12fc1cef84403f94e425b5ce2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gopeed"
  end

  test do
    output = shell_output("#{bin}/gopeed https://example.com/")
    assert_match "saving path: #{testpath}", output
    assert_match "Example Domain", (testpath/"example.com").read
  end
end
