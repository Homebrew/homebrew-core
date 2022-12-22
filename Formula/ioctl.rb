class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.9.0.tar.gz"
  sha256 "30ba810db8c6dd3e8e6465c839a24badb5f7ddbf20ce8c6c336a2ac2563ed49a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "692fc8bf140e6a015178429382d0fe1dbbc6d74ae23e43e3a4a3c56929753ca5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f19de14bf600726126a15ac1dcfeb6c9b3d5663fea4a8aaaf0cbbcd6b93600d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4350dde4410147d7e3a937c0ec8b67120882785fd21b67138ec15df65c59a711"
    sha256 cellar: :any_skip_relocation, ventura:        "181c062b1ea55577fb60fa8c7ccc7effc48c7044f335418bce8976830c36e38f"
    sha256 cellar: :any_skip_relocation, monterey:       "5955f7493b7ffa0f366d10a77f636ae0743df954daaacbf159a59441f0511fa0"
    sha256 cellar: :any_skip_relocation, big_sur:        "06c0e8338b9c1dcdff6152d696da32abf11bf24a5f633c26f26440f361c88882"
    sha256 cellar: :any_skip_relocation, catalina:       "f8f0c9f42c15e6e99e002178d0dc76c418b4388d7df85f4181e05f5f89a7e11d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f35ef6e551cdd9c937248a70d141f2dce8df669b04e435b71d7899ecf4e497c"
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
