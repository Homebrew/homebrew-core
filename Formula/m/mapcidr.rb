class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/mapcidr/archive/refs/tags/v1.1.11.tar.gz"
  sha256 "22f11f2eb00415f1a2b730d70df8a18c72313956d73e70c2afe3aba28d150b9f"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a49ffb92082c9bd14757ff3192005b04bc70dc2d88632b8916ce17459b01aa5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd3edff302e2c02555c2771a6bd8a4523f618c8546d27baf6a2b8c6d822a8a81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b706128131b0651d73ec9cc7858649dc667b2e3683467bd9060d46c2ed178cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "4bd000b206d8f431d163f699f88e280c4ed0741985e8a3201b6f0cacc470fbdb"
    sha256 cellar: :any_skip_relocation, ventura:        "e7974d18827b375272845b7bf2a0ccc791ca5ece1fb5fa1fc5f1bcdeff91e730"
    sha256 cellar: :any_skip_relocation, monterey:       "c4c420b036ab911df5cda9174b7744e762b9adf5b24fd78a224bccb00799c6ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e3b7831ff2d93f77ca74696017c37ffcd47b9d150a4c7798f00ad7000b86ae6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/mapcidr"
  end

  test do
    expected = "192.168.0.0/18\n192.168.64.0/18\n192.168.128.0/18\n192.168.192.0/18\n"
    output = shell_output("#{bin}/mapcidr -cidr 192.168.1.0/16 -sbh 16384 -silent")
    assert_equal expected, output
  end
end
