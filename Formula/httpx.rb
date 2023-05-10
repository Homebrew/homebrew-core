class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "07d314a37e9d93f884b9409c67eabd6cbe9bef0c9c7c30a85bf696ef5412447d"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4eff893c8ed7afcd209b9f05cf022f88999ded1079ade1897021b19d8ad99210"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e42c3f26181838c431730a837a11341aa41ab77791af7a25708b5045f934561"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71740b2ad4e037a1dff6c22a2527ac2d3581b580576f4bf8e974fd3098d62a80"
    sha256 cellar: :any_skip_relocation, ventura:        "3048fa8274352c06b230edba239c0f19446a76bae3e90a7687eadb2457dfae3a"
    sha256 cellar: :any_skip_relocation, monterey:       "730d2584f60d6d69772f83610a2f630e0098ad4d8c520cdd209fee7db0eed7dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "85b0d7837dd301289f2c39701a5bc40ca41a7eab6f57c3e14d7db4e87d8c4807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11cf199e126228ebd86e9039361bc73195ac90e21a30a740ee554a3dbf21b518"
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
