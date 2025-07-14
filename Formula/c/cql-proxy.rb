class CqlProxy < Formula
  desc "DataStax cql-proxy enables Cassandra apps to use Astra DB without code changes"
  homepage "https://github.com/datastax/cql-proxy"
  url "https://github.com/datastax/cql-proxy/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "f781abd69142551bc90e98bf986e82c191a39a9e1c45370d12a073268bc79c86"
  license "Apache-2.0"
  head "https://github.com/datastax/cql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4956cf9eb3aac88e7b3706870559e78ad8d7bf2f84470b858813ec6f3f2d674e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2dc499bc83523870318cb45457c8dbf5463b38613e8ba898eb40f3cfb26ed15e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1341c402de442c3c8dc05e77ba655c372c14bdca32b36b3078be628fc62ee25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c03fd5277a1fefba5da878800cf8c0d5efb8913a34850a60e840150f3a8c5508"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e6e2bb6fb905db404f8912cc49e55a8d3dda016513e4eb683c89903161c8ddf"
    sha256 cellar: :any_skip_relocation, ventura:        "ea58fa6d3a9d6987cb1b67f88ee2f14bcd83d8502b9d848e2cba7528fb0b8637"
    sha256 cellar: :any_skip_relocation, monterey:       "6dc0f64f5ddd99e41653adda5e140c47aeb03c5a612a3f656f52e30209144a73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf5794b3521badaf76342cd4bcc83df09d26e3e77e7a2c9e1942ce3fcfb817ca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    touch "secure.txt"
    output = shell_output("#{bin}/cql-proxy -b secure.txt --bind 127.0.0.1 2>&1", 2)
    assert_match "unable to open", output
  end
end
