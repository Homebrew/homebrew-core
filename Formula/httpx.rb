class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.2.0.tar.gz"
  sha256 "f4f5c478f966a1d60373c74bfa1e934c9858c0502e2da1819ca00ef7e0fb1ee1"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98851efed9baef9f0adeb339b6f9308e2f7f11bc9e6b702c22938b5e5f99fec7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e79859079b920f030243af6f2d9332895d7745879fd3963ab262ed09f44ea9f4"
    sha256 cellar: :any_skip_relocation, monterey:       "4cd92a1f94d8befcf8cf84fd76fc3ee5e950b7c6ad0997f4071b78b73a5f4837"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcc78ce8d87134dd5d2381e5a3d87c076003f76b8d6b878cd20d9fc93888fdd9"
    sha256 cellar: :any_skip_relocation, catalina:       "faf1d4f61ca079acc894be34a1c0ad5943a76678bdeb24e473bf4a624486b7c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c65ceaa745489f84ae7d98883085679052068d0702c6fbb70e6e86722893be3"
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
