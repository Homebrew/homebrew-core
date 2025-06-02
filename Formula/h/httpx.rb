class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "119b725844422f8c39f01d39cd738cc14eba43d9e2637ec2794af1aec4e3be3a"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35112d82ea01cc70c621469fa2816f0586232614dee5d2fca1c951cff9c9c505"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd1371837ea36e01fead639803499bc7b114e091ef829259dd5ae157ee47c872"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d50000119001e207dc548787e4322810d86c7cf85ee756d8da9cf16205a6777"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4c9cdcaa13dceb559505e937295185cd0399df1cf9ee3f0606f7f6cf1084f40"
    sha256 cellar: :any_skip_relocation, ventura:       "eb1289adb465eb9d87863760ba58883d83a441bcc21a86328208ec3e0ed9ed83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e957e22724c8ce9f1aa8aea2f52c83bccccf60dfc918bec733d7d1bc41d93fc0"
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
