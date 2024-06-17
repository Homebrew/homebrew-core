class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v1.14.2.tar.gz"
  sha256 "c515d890de59b2aad31833f66c035c1cc91ef5b408f4189f0166a7833111c606"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0554f345ebabb86875eee75ebacd7896ae4054f3b8cd013ec26c93a890f327c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d20e56ac27cb204f837c2b004df71f80b95ab4b0b7e69ab756d9aebe1f5573f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ba6693dcf82bbb1958610f27083634651e7dcc3c465fa9a94385d4a52c28975"
    sha256 cellar: :any_skip_relocation, sonoma:         "960ce48f22afb056a802583e292c443c509bc5eeaf71e653a83497d5e8705814"
    sha256 cellar: :any_skip_relocation, ventura:        "0070dafbce9cf1bbc4f925a399cf84ba4d6e52e7acaddfda0e4495de51a678a4"
    sha256 cellar: :any_skip_relocation, monterey:       "c5d27385a0448a2b4a32de1add658af8b3fb6276ba7db12bc0c5f651709f702d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63027b89ee461f765ab7b3956a38a344f065adade7792d3c8342cdf33f219e80"
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
