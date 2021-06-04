class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.0.9.tar.gz"
  sha256 "a1d440fd464c6770730be30624b83191af895e4c19a95d2cc0d2b851be00bc4d"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a9c7aec3ec19b10a452349c30807222b6c85578edddbbd57659d3b316559dbdd"
    sha256 cellar: :any_skip_relocation, big_sur:       "6aa23319957c0485d20cfbcc7f36443b791ecef28b25579f9c11dec528c3d014"
    sha256 cellar: :any_skip_relocation, catalina:      "7a295b86be3595d442632d412fcfcdcdfd16b4d0329e694361b81319e41dcad3"
    sha256 cellar: :any_skip_relocation, mojave:        "9a9d9386dc2b4e577051fad6d1c0a2c77e6a662ed1dcde1e0b16f58d536ed71c"
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
