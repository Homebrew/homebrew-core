class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/mapcidr/archive/v1.1.1.tar.gz"
  sha256 "12a7dee0dd2c02eb339d308e7144bb12610e515e5ae8ae720bf2ce9ed7ed9b78"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3667b720dfd446b45e4c556444e81ecb141ec953383aae07e7e6491eac981cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3667b720dfd446b45e4c556444e81ecb141ec953383aae07e7e6491eac981cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3667b720dfd446b45e4c556444e81ecb141ec953383aae07e7e6491eac981cf"
    sha256 cellar: :any_skip_relocation, ventura:        "5ee6341e0850aa16f5df3fb9913ae47dbebe6c3c4903051b7253829cc5015c53"
    sha256 cellar: :any_skip_relocation, monterey:       "5ee6341e0850aa16f5df3fb9913ae47dbebe6c3c4903051b7253829cc5015c53"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ee6341e0850aa16f5df3fb9913ae47dbebe6c3c4903051b7253829cc5015c53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3234232749e19be02e13680689475f6a218788a1c47d209051b7130a64da36f2"
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
