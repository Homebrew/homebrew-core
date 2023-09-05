class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/v1.11.1.tar.gz"
  sha256 "4563ffe618087fdc928f7df3d20d75ebf2afcbde03327b6c11f90a3f4fed223c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0b38f1147e0f66fbef5cce51853b86a23aff4b801e4c4519c77cb68331bac88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1deca94389ed0f4b5d764f20a47daee5584cef924491792ea7ea7340f3c47b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e01b54f3a5a4ba7cd9e2d91830e5c0242a427503a5ade0498e68dcd23d3f23c"
    sha256 cellar: :any_skip_relocation, ventura:        "a157636a1d181951ec6332b904a29466a8fb58ab95f4ab66eff9c63d2bc77103"
    sha256 cellar: :any_skip_relocation, monterey:       "7273b61b29dc0cb3e28c9445d4cdbcbffffef3e72ede31b9d15639be8444ae98"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9f91c6e5b1181e1e26e466de4f7e092e395dbc2dcbc53b0016905fd61135939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "445490fd2917b538aa7e617127a53437159b48757333167d19e817f16f523bb2"
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
