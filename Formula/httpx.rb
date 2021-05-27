class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.0.8.tar.gz"
  sha256 "38b600934ea0dbe31b23c5e1a13f3c201f6392f38bf46ce02f94a2b55d824c5e"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9af34ee099be8f9275c926e5258ed96e85884480703320debad5c4e64df78074"
    sha256 cellar: :any_skip_relocation, big_sur:       "d44849f851f4b668988368ef6abe2e8ae19433ef07072da41afdf4f05c46fdb0"
    sha256 cellar: :any_skip_relocation, catalina:      "7ab6178965d4c23e3edd331016f3238a4d9ac9f3a11d7d071e0b522b2d701314"
    sha256 cellar: :any_skip_relocation, mojave:        "e6ccb705555789eb4aaa7c295948dc7d8480df28a3f4257a74da8e0c00871517"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/httpx"
  end

  test do
    output = JSON.parse(pipe_output("#{bin}/httpx -silent -status-code -title -json", "example.org"))
    assert_equal 200, output["status-code"]
    assert_equal "Example Domain", output["title"]
  end
end
