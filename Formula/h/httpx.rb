class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "4e24f4d877d4951525954352a81d9b5a29a6a784b48a9aa66a3c9e1f92b3a1fd"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7987afba78eed331caa1e98202be1aa8627951e7ed6d39a28b606d4f1731a24e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d8b19a1623a47f37c0075b387b7981530fe5fecef632ff3cabbd75ae32e6cff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ee7b434669383bda6d2ecf5440171da466149ff95c1eb945c1ffb1c88494629"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3716c1e1f58c7d7885500d45ccb937fe39e7aef7a70d7a6f2df9b9e8d9f56af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab30fed23c3987757f83508078aa871ef97cb610a567187200735e882a4174a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed81c71788dcffb3f6169171d9a47da3d3a8be873edf99a6db7256fd514d28a1"
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
