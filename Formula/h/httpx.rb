class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "f9005cd1279bc1921915268d96e56556ecf99e85d564e4fd7dd65dd219ba1513"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf38baa316240c7decce035664de8a5e8a5c6c45a2eaa1d6d7490b199b584890"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b69063d1284094d5a0e7793432f913240d21790ba2f121013564654dedef744f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a79e3b42b70fc00164ca0ed048a2834b94c29f7c26d7e86e8a842cf009d75e6"
    sha256 cellar: :any_skip_relocation, ventura:        "acbe19638db8a571fbf67cf3cab6323eb80dddd202fe040f3a94e1fe76c1c90c"
    sha256 cellar: :any_skip_relocation, monterey:       "7db049324bc8a4db56ff074c459c7160468ef88b1019fbeff792d53482c9f201"
    sha256 cellar: :any_skip_relocation, big_sur:        "f78513f35c97b5374a4ca4bc164dc9d3d6d28d75c56a5192dbaaaaf23c5c3fe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d1e86a283db2e647ed59717da387d66b2ca8a4b6433c5cebe3ad7ed4b87f200"
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
