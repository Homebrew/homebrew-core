class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/mapcidr/archive/refs/tags/1.1.94.tar.gz"
  sha256 "2c905a2993638d57dc335005a709e19e37ba8c6512f2a8136a7df278cd49df08"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "686bfce3317571c04dce3cac870517c935268e7640c10430066ef36f51936079"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dac8b92952f6143c0083c49aaec1806fd1f5bde2c26a6671f98450623820ebe0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71df5c68774568b12f5edc82f3ea2eb792f10c7602a03099fa85f2ced8b46c0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a4b205a3339eeb94c4ce605303fb7be40c1c0a9ef2a3567dd0fbb0702c84c9b"
    sha256 cellar: :any_skip_relocation, ventura:       "a0ead83131742a6efcd5d84694521041d359bb131dfdeb7b08fd3cc673b92b94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70109f0a3ef54ef62fd245cc4e05e598c342812a2e390b0670d28799509958ed"
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
