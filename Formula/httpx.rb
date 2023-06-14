class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "b2e50979bc6396c4ed35af2665aa100b5935497d23347c714241eadf2f285bdb"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cdb3149f88ffa9550eda12b7f5537c12ddc07fb0b4ef0318bfddf34d989f74a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5543dd695b0e1ca713069be3a3ca5010507f67eeb9097b5af9dd4877d9f144f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc8c1ed34dd5c29845ba0038162a189f689afe97ab26cf91cff63c40b817813d"
    sha256 cellar: :any_skip_relocation, ventura:        "1fb441fcd7ed1760cfc4539de3110d2480311144705a66debeefcec0491d4c45"
    sha256 cellar: :any_skip_relocation, monterey:       "0ed86a309efeba8e99e808518178d2090ec900c60cd9eabb9eede3f7500e592a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f9641e57a7dbb18da41ae5c5e789e2edc49b12db8c44d3499f618ea51887a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05540ebfda22dcd84d67572c8235b15f2ef0b63cb4c44b5877d9091dbdd1bc3d"
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
