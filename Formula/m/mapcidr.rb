class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/mapcidr/archive/refs/tags/v1.1.95.tar.gz"
  sha256 "f5d501a3cc742fac78ad84c9534af8342dd3936245f89ec85511e2bc4fb64dda"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8cdcb2bda8f943721a3f86b49621930c1aaecc5c9fea53e76abdd4888d75369"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e1a90b03b64e230a8765cbfa490ef9cb6fd05708e172f0bedcfc48c18bcefe6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4560d50968443f512b981abccb15b2ffb7e1fb83ea755081d1b4b91f364c62ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a9c7dc0495665e22afb09ce2c10a13820e11693020cc33ca902cf35f384c5c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56ea4d7d25ba222cd69ad9de7642a1dbc515aa5d2303fc1d09e5f7e9a978c4c8"
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
