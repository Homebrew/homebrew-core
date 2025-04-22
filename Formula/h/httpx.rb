class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/refs/tags/v1.6.10.tar.gz"
  sha256 "91fd5083b4ad5a60afea8296fc87cd6b28ad8a4027cf3e04cc9de00d657e68e0"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3d81afbe100e1c3b3db7e11435fab4509727a549e8acd9a773120022b747509"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d08a75e54780e678a33f64241c08b895afe67470ca2420005a29c87783c8497d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "045e2835bf9b60d4d920c5aede11335fde23654db6b2b0d52a2611ff8cf4c39d"
    sha256 cellar: :any_skip_relocation, sonoma:        "25601815aa434b64037f3d775d2b094caac6dfd9610cb946e17d02ed70d76a8f"
    sha256 cellar: :any_skip_relocation, ventura:       "25ceaee1ea9f863fc6db1d342fb6a8c42b3a4ba0367579005c4605f4ea45b60b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b08ea024457c2f7ffe73083cd36150d95e106a841a1977f301c7b81ab5995fbf"
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
