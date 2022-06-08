class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/mapcidr/archive/v1.0.0.tar.gz"
  sha256 "2e3a0fc4301c6c5ebee75a9c6b7dd2e1c646dc5d67b74f97dc3e2eb187a133de"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ac41e42c44274af1087f7617d6117852d296a709256aca843e5fcce21faeb6e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fe71eadf1f11dd53d1f3f80d5e4b5452726b7354b7b1ee4730b78bbabff54ce"
    sha256 cellar: :any_skip_relocation, monterey:       "02177d42c47d6efcf58e723fef68b350de0a690f27bd5567c9cc02f46b7bd9a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a3b04d400948239f5ae413b07a3a0eb0b07e7352d2d0c574a63fc7141b8562d"
    sha256 cellar: :any_skip_relocation, catalina:       "5489ac992a3a2e420be5e4c08c3c4d0cc73f6af269706cc35cd8e4a5fc0b0fc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75fed0d65b5882bba6a5c32a84f8c834bcc55e3d68b2c5dcde1337f198cbcd46"
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
