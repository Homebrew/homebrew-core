class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "4a0f847eff04b484686260792f8e0c6fe279c10a2572e8a14e7e6603a45e2d27"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1993646a6a0e70f89bd418b513ab4c24561bd8e47ad8c327527b4deddbc3a50a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00c5aa32bc7d8b1f98286bc98b9e93b1e0eae07ee7a8b2c592f61e06547263ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e9ba16f6bf34057adef86753f596843bb763d0a5f3393f32eb6aeb348219ba9"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb9ba7e224d72246227f1dd9d0783bd0289400d41f3499c5a28e72f7b3675e71"
    sha256 cellar: :any_skip_relocation, ventura:        "a80d11b61104896da13a47fe29c1be31b523394f5da2aecdac41cc2eaa562775"
    sha256 cellar: :any_skip_relocation, monterey:       "e54a22980f4cffd425bfaf728281990e266a192513edd7e835dc2d01d379bb98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04c522bdf9306ee63b3ddead7241e0fe165f63a99e3c7a89aa0ca0d519a7dd47"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/httpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end
