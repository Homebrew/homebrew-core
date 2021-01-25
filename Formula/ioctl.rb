class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https://docs.iotex.io/developer/get-started/ioctl-install.html"
  url "https://github.com/iotexproject/iotex-core/archive/v1.1.4.tar.gz"
  sha256 "8bc4aca80ba4a51d24aa706327600150c7fb632d76f59da0e1633076b75d420a"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a404957720d81eb86f3d6c987d9892784fae103fc2bd1d190f8aa012e4842fde" => :big_sur
    sha256 "36c60197eb59786edb16100664c35e5e52dd2e19c6047bc533df4b5a065f9630" => :catalina
    sha256 "30a08048e7fe9cb12a4ac716b98e359982ddf23e6544a982e05f5f2bfad3b560" => :mojave
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
