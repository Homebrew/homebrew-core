class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.6.3.tar.gz"
  sha256 "783c72fb8901b9cb0f33c25aa98079c4f5e21657d02c4379bb5c9303c38448af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "655ab814a74cfd55276cf1a7e43af539e8dc01b4a291017420cbc80890baaaf2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "707a90c46dcd0384a3acd6e01517b8c450a207837a6ad370bbf2a592b5a42852"
    sha256 cellar: :any_skip_relocation, monterey:       "4e40a57f1d3bdf7da3ade977882931e76eae2280b92b8427c3e146a42e7efda8"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2bf4bffcab21572c5b51b3b8152e27e7f54dcd153a84e067949039760089172"
    sha256 cellar: :any_skip_relocation, catalina:       "57fd2cacf9de413be4815aa8051965b02a54b606f16a3f227a4b414394d00772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f54550e51659902683f7f47b4dda4da5bf210dfe4fdf4b5aad93e87b20555d48"
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
