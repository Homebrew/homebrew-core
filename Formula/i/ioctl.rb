class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/"
  url "https://github.com/iotexproject/iotex-core/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "a01759599c72bddded99c19e6a49fa97f0a142ec5b28d083ca652e2c8f5096ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "055e9d9b5befe52655621b2092442b4673926c75ad5e94f1a6a4e4ef930e462e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d27f85655e909f29f3bc48ff09ec25840bfc5a76c272f0eae87168e7dc38d07a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5378979b937401768639cfff11ee4a74c283bae38c4ff7c0b296ced9935f87cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec8b227729bab27f84906e5982432631772129361b14b233e1ecd64dca930d14"
    sha256 cellar: :any_skip_relocation, ventura:        "19630e031483ce08ff43754975aa9bc9c65cdfece067e78010d7534dc83beb96"
    sha256 cellar: :any_skip_relocation, monterey:       "53364e6b0e8372e161f208bf73b9c3563ae11f1ba1d20b4ccdd3429ed0f920e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94add6c71700fff00cc6debfacefa7a57a791f740e0b35f2f49f52974c7cb05d"
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
