class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/mapcidr/archive/v1.0.2.tar.gz"
  sha256 "c77ba39d93566512cacea672c4c595881fe4a36b29fab909fd61aba80b0646db"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e66c9864c26f4b9b96fe649ffdf0f76998641ac5e83119aed9770852e306f74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "064b51df363d485f1ed6411488beec2366040cce8703da981dd8dc12cf72f302"
    sha256 cellar: :any_skip_relocation, monterey:       "95afb257909d16239b59c4615427647b2df094026f96a48c6fbac89504aed48f"
    sha256 cellar: :any_skip_relocation, big_sur:        "21f9de858d7f1347eebb92d2ef5b135788144535cdf13a1ecad20583c330b326"
    sha256 cellar: :any_skip_relocation, catalina:       "4bbb48da30d0ca0c241ebe382c031b4fa8170ac738a925db5e0c7e866296fc2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a62bfbfdeb6d79df4a949784ed359fb9e87820a61a1346092b2ac7a8745a33c5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/mapcidr"
  end

  test do
    expected = "192.168.0.0/18\n192.168.64.0/18\n192.168.128.0/18\n192.168.192.0/18\n"
    output = shell_output("#{bin}/mapcidr -cidr 192.168.1.0/16 -sbh 16384 -silent")
    assert_equal expected, output
  end
end
