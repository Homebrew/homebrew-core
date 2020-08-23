class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/v1.1.4.tar.gz"
  sha256 "fb5fae5ef7ef45217a238b59ed16095960c197c6f8b2f460873a445dbc80c2b4"
  license "GPL-3.0"
  head "https://github.com/projectdiscovery/naabu.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1e9c6b69d6b8c8c325fb351e26f0820802fcb6bbdb35359a88845a69ffb2df1" => :catalina
    sha256 "e300d1ecc613eea764fd9826cf7c46b2c98f1e92cc9a49463aa7e20f5d068e35" => :mojave
    sha256 "a12a9444acb90e7f1b790f5f4535de9f7889a3beedd89b03d8dc56d3c4954be9" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/naabu"
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -ports 443")
  end
end
