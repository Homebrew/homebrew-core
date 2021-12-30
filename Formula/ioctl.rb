class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.6.2.tar.gz"
  sha256 "08f5de1409fc872326c6ca170a62c7e2683f4a5f376959598f7979ea499bef74"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef013f02834e7539e6bb03a4f89b17898c18256433153fcaee96d088ae78af8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea8940f49456749e32fdb303d62903a31b93cc72e72d03f29c51310cc0384206"
    sha256 cellar: :any_skip_relocation, monterey:       "3f574b3889c845d14e10f881dfc0154d5ef33344d7297e827545eafa498d32a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "0786cbff246f0141786ffd5f12d39576795e72dee04d716b382da199ba6b78b3"
    sha256 cellar: :any_skip_relocation, catalina:       "ceda3a4c726b14a10122dc4e16c80859ff62c6d2b85a07c8f4980c6436d13723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55a9da98e601644055cdc3eddb44d5e9547ed4c69004bdfe314b367062a8bdc2"
  end

  depends_on "go" => :build

  def install
    system "make", "ioctl"
    bin.install "bin/ioctl"
  end

  test do
    output = shell_output "#{bin}/ioctl config set endpoint api.iotex.one:443"
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end
