class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "e47e7643cf736d86769961865ca21e7f0a3269af5b00c534d3816eb04a60f7b7"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9711f3fb90d287dc2e0400e1517d74dc40d3f8f4e168766e602a56cf23656c82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd5685d3504a26b6227f45ca1c0601e4e08624d6df776db4a3e2e0c47c5394ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "958c58b56e64ebc0d6986d02e062d07777e99affaecf6e29d5e30252c6aaa560"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4757e8714859c18224b00fa223b0362cff43251f68ac69c4417ee102ff8a5a02"
    sha256 cellar: :any_skip_relocation, sonoma:        "f479dec45d1193d11c410fe7b3c9258e35d584ca16d6a78f20db3dabd49a99c9"
    sha256 cellar: :any_skip_relocation, ventura:       "22fbedf864cf9563c3b1d07ed3168dd84c5872ef9a08109661cb720aa431b180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a1c2d362d76c5d35361ac41fac8bbcefa94dfef18d158dbabd0c1ea484a3281"
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
