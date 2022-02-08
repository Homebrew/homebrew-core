class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.6.3.tar.gz"
  sha256 "783c72fb8901b9cb0f33c25aa98079c4f5e21657d02c4379bb5c9303c38448af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "274d0953d08063942c08997e2c9ca33b22c81d51a5fd33dfe93c1cf28c492a66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2af91d67f34c71d32e6d34c25e28ca9b772ec35c76fada466cdee1902d44fd17"
    sha256 cellar: :any_skip_relocation, monterey:       "919ad5e9453aaa0444d16c46b770863203cb7a57fcd1dce6bdb5e2ec367e87c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb2204d96a2c39264cdabc1af9a202d6a3003abf48b9d3fc5395a8bac2086b2b"
    sha256 cellar: :any_skip_relocation, catalina:       "1efb4da99fe32388fcbc76ae96a7d1aac5b04e95ba939d427d4cd94f911ebdf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19f938962ba0e88bb1f8cab319f2a176d8f999576b3c9fc3b797eff1ae4103d5"
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
