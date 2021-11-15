class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.1.3.tar.gz"
  sha256 "900832e2389ac2f591fc8c589a4e7c3dd955773f4446d81bb7395393f7c340e3"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eeaf113ce9f78470b7f9ac47a7340fb6e85d820efb8da24da299e96059c1fa16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0db77b4476e31fa83186ba12f194b7a8b41282c06bd8a89f35dd86bb7045deeb"
    sha256 cellar: :any_skip_relocation, monterey:       "58e01d5cba1b5cbb0b1ef5adaa3bb287e7a2c3709480946e71752586a6b9b823"
    sha256 cellar: :any_skip_relocation, big_sur:        "255750ec7fd6c3d64eca16663b2a20bd43b72b0d9513dd58f19bf58874fe6b57"
    sha256 cellar: :any_skip_relocation, catalina:       "0dcf11eb93bd23ce1daf15cfd80e8ade74fd89a575418feab775e9a6016d2fae"
    sha256 cellar: :any_skip_relocation, mojave:         "ac955c24989c8a36f5e8bc6c6713fa2cd9484c646934d97e2eef99f57afa088a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8918d5e1258b1c75d4625c4a33195633e47248212bf6ecc2f8e12c83de09ef1d"
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
